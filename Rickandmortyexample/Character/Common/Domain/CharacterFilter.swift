class CharacterFilter {
    var name: String
    var species: String
    var status: Character.Status?
    var gender: Character.Gender?

    init(name: String = "", species: String = "", status: Character.Status? = nil, gender: Character.Gender? = nil) {
        self.name = name
        self.species = species
        self.status = status
        self.gender = gender
    }
}
