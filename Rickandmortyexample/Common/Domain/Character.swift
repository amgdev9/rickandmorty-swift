struct Character {
    let id: String
    let imageURL: String
    let name: String

    enum Status {
        case alive
        case dead
        case unknown
    }

    enum Gender {
        case female
        case male
        case genderless
        case unknown
    }
}
