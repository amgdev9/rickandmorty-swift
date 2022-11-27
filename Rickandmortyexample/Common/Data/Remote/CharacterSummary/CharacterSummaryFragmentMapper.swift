extension CharacterSummaryFragment {
    private static let toDomainStatus: [String: Character.Status] = [
        "Alive": .alive,
        "Dead": .dead,
        "unknown": .unknown
    ]

    func toDomain() -> CharacterSummary {
        return CharacterSummary.Builder()
            .set(id: id ?? "")
            .set(name: name ?? "")
            .set(imageURL: image ?? "")
            .set(status: CharacterSummaryFragment.toDomainStatus[status ?? "unknown"] ?? .unknown)
            .build()
    }
}
