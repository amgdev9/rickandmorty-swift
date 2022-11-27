extension EpisodeSummaryFragment {
    func airDateToDomain() -> Date {
        guard let airDate = air_date else { return Date() }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        return formatter.date(from: airDate) ?? Date()
    }

    func toDomain() -> EpisodeSummary {
        EpisodeSummary.init(
            id: id ?? "",
            name: name ?? "",
            date: airDateToDomain()
        )
    }
}
