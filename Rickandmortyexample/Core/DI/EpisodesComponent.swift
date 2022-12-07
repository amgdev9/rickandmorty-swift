import NeedleFoundation

protocol EpisodesDependencies: Dependency {
    var apolloClient: ApolloClient { get }
    var realm: RealmComponent { get }
}

class EpisodesComponent: Component<EpisodesDependencies> {
    var showEpisodesViewModel: some ShowEpisodesViewModel {
        return ShowEpisodesViewModelImpl()
    }

    var episodeDetailsViewModel: some EpisodeDetailsViewModel {
        return EpisodeDetailsViewModelImpl(episodeDetailsRepository: episodeDetailsRepository)
    }

    var filterEpisodesViewModel: some FilterEpisodesViewModel {
        return FilterEpisodesViewModelImpl(episodeFilterRepository: episodeFilterRepository)
    }

    var episodeFilterRepository: some EpisodeFilterRepository {
        return shared {
            RealmEpisodeFilterRepository(
                realmFactory: dependency.realm.realmFactory,
                realmQueue: dependency.realm.realmQueue
            )
        }
    }

    var episodeDetailsRepository: some EpisodeDetailsRepository {
        return shared {
            EpisodeDetailsRepositoryImpl(
                remoteDataSource: episodeDetailRemoteDataSource,
                localDataSource: episodeDetailLocalDataSource
            )
        }
    }

    var episodeDetailRemoteDataSource: some EpisodeDetailRemoteDataSource {
        return GraphQLEpisodeDetailDataSource(apolloClient: dependency.apolloClient)
    }

    var episodeDetailLocalDataSource: some EpisodeDetailsLocalDataSource {
        return RealmEpisodeDetailsDataSource(
            realmFactory: dependency.realm.realmFactory,
            realmQueue: dependency.realm.realmQueue
        )
    }
}
