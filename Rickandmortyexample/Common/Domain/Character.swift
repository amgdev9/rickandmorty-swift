struct Character {
    let id: String
    let imageURL: String
    let name: String

    enum Status {
        case alive
        case dead
        case unknown
    }
}
