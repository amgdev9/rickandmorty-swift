import RxSwift
import CoreData

class CoreDataCharactersDataSource: CharactersLocalDataSource {
    let context: NSManagedObjectContext

    let observable: Observable<[CharacterSummary]>

    init(context: NSManagedObjectContext) {
        self.context = context
        observable = .create { observer in
            let notificationCenter = NotificationCenter.default
            let coreDataObserver = CoreDataObserver(observer: observer, context: context)
            notificationCenter.addObserver(coreDataObserver, selector: #selector(coreDataObserver.objectDidChange),
                                           name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
                                           object: context)

            return Disposables.create {
                notificationCenter.removeObserver(coreDataObserver)
            }
        }
    }

    fileprivate static func getFilter(context: NSManagedObjectContext) -> CDCharacterFilter {
        let filter = CDCharacterFilter(context: context)
        filter.name = ""
        filter.species = ""
        return filter
    }

    func getNumPages() async -> Result<UInt32?, Error> {
        let request = CDPaginatedList.fetchRequest()
        request.predicate = NSPredicate(format: "characterFilter == %@", CoreDataCharactersDataSource.getFilter(context: context)) // TODO Filter
        do {
            let result = try self.context.fetch(request)
            if result.count == 0 { return .success(.none) }

            return .success(UInt32(result[0].numPages))
        } catch {
            return .failure(Error(message: String(localized: "error/database")))
        }
    }

    func getCharactersCountSync() -> Result<UInt, Error> {
        let request = CDPaginatedList.fetchRequest()
        request.predicate = NSPredicate(format: "characterFilter == %@", CoreDataCharactersDataSource.getFilter(context: context)) // TODO Filter
        do {
            let result = try self.context.fetch(request)
            if result.count == 0 { return .success(0) }
            return .success(UInt(result[0].characters?.count ?? 0))
        } catch {
            return .failure(Error(message: String(localized: "error/database")))
        }
    }

    func getCharactersCount() async -> Result<UInt, Error> {
        return await withCheckedContinuation { continuation in
            context.perform {
                continuation.resume(returning: self.getCharactersCountSync())
            }
        }
    }

    func getCharacters() async -> Result<[CharacterSummary], Error> {
        return await CoreDataCharactersDataSource.handleGetCharacters(context: context)
    }

    fileprivate static func handleGetCharacters(context: NSManagedObjectContext)
    async -> Result<[CharacterSummary], Error> {
        return await withCheckedContinuation { continuation in
            context.perform {
                let request = CDPaginatedList.fetchRequest()
                //request.predicate = NSPredicate(format: "characterFilter == %@", getFilter(context: context)) // TODO Filter
                do {
                    let result = try context.fetch(request)
                    if result.count == 0 { return continuation.resume(returning: .success([])) }
                    let characters = result[0].characters?.array as? [CDCharacterSummary]
                    guard let characters = characters else {
                        return continuation.resume(returning: .failure(Error(message: String(localized: "error/database"))))
                    }

                    let domainCharacters = characters.map { $0.toDomain() }
                    return continuation.resume(returning: .success(domainCharacters))
                } catch {
                    return continuation.resume(returning: .failure(Error(message: String(localized: "error/database"))))
                }
            }
        }
    }

    func insertCharacters(characters: [CharacterSummary], numExpectedCharacters: UInt, numPages: UInt32) async -> Result<Void, Error> {
        return await withCheckedContinuation { continuation in

            context.perform {
                let numCharacters = self.getCharactersCountSync()
                guard let numCharacters = numCharacters.unwrap() else {
                    return continuation.resume(returning: .failure(numCharacters.failure()!))
                }

                if numCharacters != numExpectedCharacters {
                    continuation.resume(returning: .success(()))
                    return
                }

                do {
                    let request = CDPaginatedList.fetchRequest()
                    request.predicate = NSPredicate(format: "characterFilter == %@", CoreDataCharactersDataSource.getFilter(context: self.context)) // TODO Filter
                    let result = try self.context.fetch(request)
                    guard let list = result.first else {
                        return continuation.resume(returning: .failure(Error(message: String(localized: "error/database"))))
                    }

                    let listCharacters = (list.characters?.mutableCopy() as? NSMutableOrderedSet) ?? NSMutableOrderedSet()

                    characters.forEach { character in
                        let characterSummary = CDCharacterSummary.from(character: character, context: self.context)
                        listCharacters.add(characterSummary)
                    }

                    list.numPages = Int32(numPages)
                    list.characters = listCharacters.copy() as? NSOrderedSet

                    try self.context.save()
                    return continuation.resume(returning: .success(()))
                } catch {
                    return continuation.resume(returning: .failure(Error(message: String(localized: "error/database"))))
                }
            }
        }
    }

    func setCharacters(characters: [CharacterSummary], numPages: UInt32) async -> Result<Void, Error> {
        return await withCheckedContinuation { continuation in
            context.perform {
                do {
                    let request = CDPaginatedList.fetchRequest()
                    request.predicate = NSPredicate(format: "characterFilter == %@", CoreDataCharactersDataSource.getFilter(context: self.context)) // TODO Filter
                    let result = try self.context.fetch(request)
                    if let list = result.first {
                        let listCharacters = list.characters
                        self.context.delete(list)

                        listCharacters?.forEach { listCharacter in
                            (listCharacter as? CDCharacterSummary)?.deleteIfSafe(context: self.context)
                        }
                    }

                    let newCharacterList = CDPaginatedList(context: self.context)
                    let newCharacters = NSMutableOrderedSet()

                    characters.forEach { character in
                        let characterSummary = CDCharacterSummary.from(character: character, context: self.context)
                        newCharacters.add(characterSummary)
                    }

                    newCharacterList.numPages = Int32(numPages)
                    newCharacterList.characterFilter = CoreDataCharactersDataSource.getFilter(context: self.context)  // TODO Filter
                    newCharacterList.characters = newCharacters.copy() as? NSOrderedSet

                    try self.context.save()
                    return continuation.resume(returning: .success(()))
                } catch {
                    self.context.rollback()
                    return continuation.resume(returning: .failure(Error(message: String(localized: "error/database"))))
                }
            }
        }
    }

    class CoreDataObserver {
        let observer: AnyObserver<[CharacterSummary]>
        let context: NSManagedObjectContext

        init(observer: AnyObserver<[CharacterSummary]>, context: NSManagedObjectContext) {
            self.observer = observer
            self.context = context
        }

        func shouldSendUpdateFromInserts(_ inserts: Set<NSManagedObject>) -> Bool {
            for insert in inserts {
                // TODO
                let uri = insert.objectID.uriRepresentation().absoluteString
                if uri.contains("CDCharacterSummary") { return true }
            }

            return false
        }

        @objc func objectDidChange(notification: NSNotification) {
            guard let userInfo = notification.userInfo else { return }

            if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>, inserts.count > 0 {
                if !shouldSendUpdateFromInserts(inserts) { return }

                Task {
                    let characters = await CoreDataCharactersDataSource.handleGetCharacters(context: context)
                    guard let characters = characters.unwrap() else { return }

                    observer.onNext(characters)
                }
            }
        }
    }
}

extension CDCharacterSummary {
    func toCoreDataStatus(status: Character.Status) -> Int16 {
        switch status {
        case .alive: return 0
        case .dead: return 1
        case .unknown: return 2
        }
    }

    var domainStatus: Character.Status {
        switch status {
        case 0: return .alive
        case 1: return .dead
        default: return .unknown
        }
    }

    static func from(character: CharacterSummary, context: NSManagedObjectContext) -> CDCharacterSummary {
        let result = CDCharacterSummary(context: context)
        result.id = character.id
        result.name = character.name
        result.imageURL = character.imageURL
        result.status = result.toCoreDataStatus(status: character.status)
        return result
    }

    func toDomain() -> CharacterSummary {
        return CharacterSummary.Builder()
            .set(id: id ?? "")
            .set(imageURL: imageURL ?? "")
            .set(name: name ?? "")
            .set(status: domainStatus)
            .build()
    }
}

extension CDCharacterSummary {
    func deleteIfSafe(context: NSManagedObjectContext) {
        if let episodesIn = episodesIn, episodesIn.count > 0 { return }
        if let paginatedList = paginatedList, paginatedList.count > 0 { return }
        if residentIn != nil { return }
        context.delete(self)
    }
}
