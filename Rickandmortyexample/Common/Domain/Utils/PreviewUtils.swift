class PreviewUtils {
    @Sendable static func delay() async {
        do {
            try await Task.sleep(nanoseconds: 2_000_000_000)
        } catch {}
    }
}
