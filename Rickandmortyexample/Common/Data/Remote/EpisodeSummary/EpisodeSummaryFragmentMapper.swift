extension EpisodeSummaryFragment {
    func airDateToDomain() -> Date {
        guard let airDate = air_date else { return Date() }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: airDate) ?? Date()
    }

    func toDomain() -> EpisodeSummary {
        EpisodeSummary.init(
            id: id ?? "",
            seasonId: episode ?? "",
            name: name ?? "",
            date: airDateToDomain()
        )
    }
}
