import RxSwift

class RealmCharactersDataSource: CharactersLocalDataSource {
    var observable: Observable<[CharacterSummary]>

    init() {
        self.observable = .create { _ in
            return Disposables.create()
        }
    }

    func getCharactersCount() async -> Result<UInt, Error> {
        // TODO
        return .success(0)
    }

    func getCharacters() async -> Result<[CharacterSummary], Error> {
        // TODO
        return .success([])
    }

    func insertCharacters(characters: [CharacterSummary], numExpectedCharacters: UInt, numPages: UInt32) async -> Result<Void, Error> {
        // TODO
        return .success(())
    }

    func setCharacters(characters: [CharacterSummary], numPages: UInt32) async -> Result<Void, Error> {
        // TODO
        return .success(())
    }

    func getNumPages() async -> Result<UInt32?, Error> {
        // TODO
        return .success(.none)
    }
}
