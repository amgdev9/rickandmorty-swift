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
                                           name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: context)

            return Disposables.create {
                notificationCenter.removeObserver(coreDataObserver)
            }
        }
    }

    func getCharactersCount() -> Result<Int, Error> {
        let request = CDCharacterListEntry.fetchRequest()
        do {
            let result = try context.count(for: request)
            return .success(result)
        } catch {
            return .failure(Error(message: String(localized: "error/database")))
        }
    }

    func getCharacters() -> Result<[CharacterSummary], Error> {
        return CoreDataCharactersDataSource.handleGetCharacters(context: context)
    }

    fileprivate static func handleGetCharacters(context: NSManagedObjectContext) -> Result<[CharacterSummary], Error> {
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
            return .success(characters)
        } catch {
            return .failure(Error(message: String(localized: "error/database")))
        }
    }

    func insertCharacters(characters: [CharacterSummary]) -> Result<Void, Error> {
        let numCharactersResult = getCharactersCount()
        if let error = numCharactersResult.failure() {
            return .failure(error)
        }
        let numCharacters = numCharactersResult.unwrap()!

        _ = characters.enumerated().map { (index, character) in
            let entry = CDCharacterListEntry(context: context)
            entry.id = Int32(numCharacters + index)
            entry.characterInList = CDCharacterSummary.from(character: character, context: context)
            return entry
        }

        do {
            try context.save()
            return .success(())
        } catch {
            return .failure(Error(message: String(localized: "error/database")))
        }
    }

    func setCharacters(characters: [CharacterSummary]) -> Result<Void, Error> {
        do {
            let request = CDCharacterListEntry.fetchRequest()
            let cachedCharacters = try context.fetch(request)

            cachedCharacters.forEach {
                context.delete($0)
            }

            _ = characters.enumerated().map { (index, character) in
                let entry = CDCharacterListEntry(context: context)
                entry.id = Int32(index)
                entry.characterInList = CDCharacterSummary.from(character: character, context: context)
                return entry
            }

            try context.save()
            return .success(())
        } catch {
            context.rollback()
            return .failure(Error(message: String(localized: "error/database")))
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
                if(uri.contains("CDCharacterListEntry")) { return true }
            }

            return false
        }

        @objc func objectDidChange(notification: NSNotification) {
            guard let userInfo = notification.userInfo else { return }

            if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>, inserts.count > 0 {
                if(!shouldSendUpdateFromInserts(inserts: inserts)) { return }

                let characters = CoreDataCharactersDataSource.handleGetCharacters(context: context)
                if characters.failure() != nil { return }

                observer.onNext(characters.unwrap()!)
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
