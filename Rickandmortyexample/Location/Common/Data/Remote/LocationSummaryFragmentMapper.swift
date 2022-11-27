extension LocationSummaryFragment {
    func toDomain() -> LocationSummary {
        return LocationSummary.Builder()
            .set(id: id ?? "")
            .set(name: name ?? "")
            .set(type: type ?? "")
            .build()
    }
}
