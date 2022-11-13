extension Character.Status {
    static private let localizedKeys: [Self: String.LocalizationValue] = [
        .alive: "enums/CharacterStatus/alive",
        .dead: "enums/CharacterStatus/dead",
        .unknown: "enums/CharacterStatus/unknown"
    ]

    func localized() -> String {
        return String(localized: Self.localizedKeys[self]!)
    }
}
