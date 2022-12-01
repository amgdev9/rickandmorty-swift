import RxSwift

protocol CharactersRepository {
    func fetch(filter: CharacterFilter) async -> Result<PaginatedResponse<CharacterSummary>, Error>
    func fetchNextPage(filter: CharacterFilter, listSize: UInt32) async -> Result<PaginatedResponse<CharacterSummary>, Error>
    func refetch(filter: CharacterFilter) async -> Result<PaginatedResponse<CharacterSummary>, Error>
}
