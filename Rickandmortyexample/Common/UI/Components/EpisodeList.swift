import SwiftUI

struct EpisodeList: View {
    let episodes: [EpisodeSummary]
    let onPress: (_: String) -> Void

    @EnvironmentObject var i18n: I18N

    var body: some View {
        VStack(spacing: 0) {
            ForEach(episodes, id: \.id) { episode in
                SectionButton(
                    title: episode.seasonId,
                    subtitle: episode.name,
                    info: i18n.tDate(episode.date, format: "dateformat/MMMM d, yyyy"),
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
    static let EPISODES: [EpisodeSummary] = (1...3).map { i in
        EpisodeSummary.Mother.build(id: String(i))
    }

    static var previews: some View {
        EpisodeList(episodes: EPISODES, onPress: { _ in })
    }
}
