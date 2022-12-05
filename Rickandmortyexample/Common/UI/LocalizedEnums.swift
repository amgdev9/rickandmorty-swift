protocol LocalizedEnum {
    func localized() -> String
}

extension Character.Status: LocalizedEnum {
    static private let localizedKeys: [Self: String.LocalizationValue] = [
        .alive: "enums/CharacterStatus/alive",
        .dead: "enums/CharacterStatus/dead",
        .unknown: "enums/CharacterStatus/unknown"
    ]

    func localized() -> String {
        return String(localized: Self.localizedKeys[self]!)
    }
}

extension Character.Gender: LocalizedEnum {
    static private let localizedKeys: [Self: String.LocalizationValue] = [
        .female: "enums/CharacterGender/female",
        .male: "enums/CharacterGender/male",
        .genderless: "enums/CharacterGender/genderless",
        .unknown: "enums/CharacterGender/unknown"
    ]

    func localized() -> String {
        return String(localized: Self.localizedKeys[self]!)
    }
}
