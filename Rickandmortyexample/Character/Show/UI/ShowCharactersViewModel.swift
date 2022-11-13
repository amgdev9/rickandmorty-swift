class ShowCharactersViewModel: ObservableObject {
    @Published var example = "THIS WORKS"

    func change() {
        example = "THIS CHANGED"
    }
}
