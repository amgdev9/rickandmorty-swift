import NeedleFoundation
import Apollo
import RealmSwift

class MainContainer: BootstrapComponent {
    var configuration: some Configuration {
        return shared { IOSConfiguration() }
    }

    var apolloClient: ApolloClient {
        return shared {
            ApolloClient(url: configuration.serverUrl)
        }
    }

    // MARK: - View Models
    var showCharactersViewModel: some ShowCharactersViewModel {
        return ShowCharactersViewModelImpl(charactersRepository: charactersRepository, filterRepository: characterFilterRepository)
    }

    var showLocationsViewModel: some ShowLocationsViewModel {
        return ShowLocationsViewModelImpl()
    }

    var showEpisodesViewModel: some ShowEpisodesViewModel {
        return ShowEpisodesViewModelImpl()
    }

    var filterCharactersViewModel: some FilterCharactersViewModel {
        return FilterCharactersViewModelImpl(characterFilterRepository: characterFilterRepository)
    }

    var characterDetailsViewModel: some CharacterDetailsViewModel {
        return CharacterDetailsViewModelImpl(characterDetailsRepository: characterDetailsRepository)
    }

    var locationDetailsViewModel: some LocationDetailsViewModel {
        return LocationDetailsViewModelImpl()
    }

    var episodeDetailsViewModel: some EpisodeDetailsViewModel {
        return EpisodeDetailsViewModelImpl()
    }

    func searchViewModel(autocompleteRepository: some AutocompleteRepository) -> some SearchViewModel {
        return SearchViewModelImpl(autocompleteRepository: autocompleteRepository)
    }

    var filterLocationsViewModel: some FilterLocationsViewModel {
        return FilterLocationsViewModelImpl()
    }

    var filterEpisodesViewModel: some FilterEpisodesViewModel {
        return FilterEpisodesViewModelImpl()
    }

    // MARK: - Repositories
    var charactersRepository: some CharactersRepository {
        return shared {
            CharactersRepositoryImpl(
                remoteDataSource: charactersRemoteDataSource,
                localDataSource: charactersLocalDataSource
            )
        }
    }

    var characterDetailsRepository: some CharacterDetailsRepository {
        return shared {
            CharacterDetailsRepositoryImpl(remoteDataSource: characterDetailRemoteDataSource, localDataSource: characterDetailLocalDataSource)
        }
    }

    var characterDetailRemoteDataSource: some CharacterDetailRemoteDataSource {
        return GraphQLCharacterDetailDataSource(apolloClient: apolloClient)
    }

    var characterDetailLocalDataSource: some CharacterDetailsLocalDataSource {
        return RealmCharacterDetailsDataSource(realmFactory: realmFactory, realmQueue: realmQueue)
    }

    var characterFilterRepository: some CharacterFilterRepository {
        return shared {
            RealmCharacterFilterRepository(realmFactory: realmFactory, realmQueue: realmQueue)
        }
    }

    var charactersRemoteDataSource: some CharactersRemoteDataSource {
        return GraphQLCharactersDataSource(apolloClient: apolloClient)
    }

    var charactersLocalDataSource: some CharactersLocalDataSource {
        return RealmCharactersDataSource(realmFactory: realmFactory, realmQueue: realmQueue)
    }

    var autocompleteByCharacterNameRepository: some AutocompleteRepository {
        return AutocompleteByCharacterNameRepository(apolloClient: apolloClient)
    }

    var autocompleteByCharacterSpeciesRepository: some AutocompleteRepository {
        return AutocompleteByCharacterSpeciesRepository(apolloClient: apolloClient)
    }

    var autocompleteByLocationNameRepository: some AutocompleteRepository {
        return AutocompleteByLocationNameRepository(apolloClient: apolloClient)
    }

    var autocompleteByLocationTypeRepository: some AutocompleteRepository {
        return AutocompleteByLocationTypeRepository(apolloClient: apolloClient)
    }

    var autocompleteByLocationDimensionRepository: some AutocompleteRepository {
        return AutocompleteByLocationDimensionRepository(apolloClient: apolloClient)
    }

    var autocompleteByEpisodeNameRepository: some AutocompleteRepository {
        return AutocompleteByEpisodeNameRepository(apolloClient: apolloClient)
    }

    var autocompleteByEpisodeSeasonIDRepository: some AutocompleteRepository {
        return AutocompleteByEpisodeSeasonIDRepository(apolloClient: apolloClient)
    }

    // MARK: - Realm
    var realmFactory: RealmFactory {
        return shared {
            RealmFactory(serialQueue: realmQueue, schemaVersion: 1)
        }
    }

    var realmQueue: DispatchQueue {
        return shared {
            DispatchQueue(label: "realm-queue")
        }
    }
}
