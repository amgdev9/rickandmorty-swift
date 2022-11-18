class IOSConfiguration: Configuration {
    var serverUrl: URL {
        return URL(string: ProcessInfo.processInfo.environment["SERVER_URL"]!)!
    }
}
