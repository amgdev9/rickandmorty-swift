import NeedleFoundation

protocol EpisodesDependencies: Dependency {

}

class EpisodesComponent: Component<EpisodesDependencies> {
    var showEpisodesViewModel: some ShowEpisodesViewModel {
        return ShowEpisodesViewModelImpl()
    }

    var episodeDetailsViewModel: some EpisodeDetailsViewModel {
        return EpisodeDetailsViewModelImpl()
    }

    var filterEpisodesViewModel: some FilterEpisodesViewModel {
        return FilterEpisodesViewModelImpl()
    }
}
