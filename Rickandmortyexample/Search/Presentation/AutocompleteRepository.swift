protocol AutocompleteRepository {
    func getAutocompletions(search: String) async -> Result<[String], Error>
}
