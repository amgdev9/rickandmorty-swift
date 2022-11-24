import SwiftUI

struct EpisodeList: View {
    let episodes: [EpisodeSummary]
    let onPress: (_: String) -> Void

    var body: some View {
        VStack(spacing: 0) {
            ForEach(episodes, id: \.id) { episode in
                SectionButton(
                    title: episode.id,
                    subtitle: episode.name,
                    info: episode.date.formatted(format: "dateformat/MMMM dd, yyyy"),
                    showBorder: false,
                    onPress: { onPress(episode.id) }
                )
                if let lastEpisode = episodes.last, lastEpisode.id != episode.id {
                    Separator()
                        .offset(x: 16)
                }
            }
        }
    }
}

// MARK: - Previews
struct EpisodeListPreviews: PreviewProvider {
    static let EPISODES: [EpisodeSummary] = [
        EpisodeSummary(id: "S01E01", name: "Pilot", date: Date()),
        EpisodeSummary(id: "S01E02", name: "Rick Potion #9", date: Date()),
        EpisodeSummary(id: "S01E03", name: "M. Night Shaym-Aliens!", date: Date())
    ]

    static var previews: some View {
        EpisodeList(episodes: EPISODES, onPress: { _ in })
    }
}