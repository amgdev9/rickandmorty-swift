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

    func getCharactersCountSync() -> Result<UInt, Error> {
        let request = CDCharacterListEntry.fetchRequest()
        do {
            let result = try self.context.count(for: request)
            return .success(UInt(result))
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
                let request = CDCharacterListEntry.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
                do {
                    let result = try context.fetch(request)
                    let characters = try result.map {
                        if let character = $0.characterInList {
                            return character.toDomain()
                        } else {
                            throw Error(message: String(localized: "error/database"))
                        }
                    }
                    return continuation.resume(returning: .success(characters))
                } catch {
                    return continuation.resume(returning: .failure(Error(message: String(localized: "error/database"))))
                }
            }
        }
    }

    func insertCharacters(characters: [CharacterSummary], numExpectedCharacters: UInt) async -> Result<Void, Error> {
        return await withCheckedContinuation { continuation in
            context.perform {
                let numCharactersResult = self.getCharactersCountSync()
                if let error = numCharactersResult.failure() {
                    return continuation.resume(returning: .failure(error))
                }
                let numCharacters = numCharactersResult.unwrap()!
                print("\(numCharacters) \(numExpectedCharacters)")
                if numCharacters != numExpectedCharacters {
                    continuation.resume(returning: .success(()))
                    return
                }

                characters.enumerated().forEach { (index, character) in
                    let entry = CDCharacterListEntry(context: self.context)
                    entry.id = Int32(numCharacters + UInt(index))
                    entry.characterInList = CDCharacterSummary.from(character: character, context: self.context)
                }

                do {
                    try self.context.save()
                    return continuation.resume(returning: .success(()))
                } catch {
                    return continuation.resume(returning: .failure(Error(message: String(localized: "error/database"))))
                }
            }
        }
    }

    func setCharacters(characters: [CharacterSummary]) async -> Result<Void, Error> {
        return await withCheckedContinuation { continuation in
            context.perform {
                do {
                    let request = CDCharacterListEntry.fetchRequest()
                    let cachedCharacters = try self.context.fetch(request)

                    cachedCharacters.forEach {
                        self.context.delete($0)
                    }

                    characters.enumerated().forEach { (index, character) in
                        let entry = CDCharacterListEntry(context: self.context)
                        entry.id = Int32(index)
                        entry.characterInList = CDCharacterSummary.from(character: character, context: self.context)
                    }

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

        func shouldSendUpdateFromInserts(inserts: Set<NSManagedObject>) -> Bool {
            for insert in inserts {
                let uri = insert.objectID.uriRepresentation().absoluteString
                if uri.contains("CDCharacterListEntry") { return true }
            }

            return false
        }

        @objc func objectDidChange(notification: NSNotification) {
            guard let userInfo = notification.userInfo else { return }

            if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>, inserts.count > 0 {
                if !shouldSendUpdateFromInserts(inserts: inserts) { return }

                Task {
                    let characters = await CoreDataCharactersDataSource.handleGetCharacters(context: context)
                    if characters.failure() != nil { return }

                    observer.onNext(characters.unwrap()!)
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
