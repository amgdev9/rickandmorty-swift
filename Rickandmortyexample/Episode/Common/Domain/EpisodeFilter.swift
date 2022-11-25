class EpisodeFilter {
    var name: String
    var episode: String

    init(name: String = "", episode: String = "") {
        self.name = name
        self.episode = episode
    }

    var isEmpty: Bool {
        return name.isEmpty && episode.isEmpty
    }
}
