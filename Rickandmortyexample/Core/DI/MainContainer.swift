import NeedleFoundation
import Apollo
import CoreData

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
        return ShowCharactersViewModelImpl(charactersRepository: charactersRepository)
    }

    var showLocationsViewModel: some ShowLocationsViewModel {
        return ShowLocationsViewModelImpl()
    }

    var showEpisodesViewModel: some ShowEpisodesViewModel {
        return ShowEpisodesViewModelImpl()
    }

    var filterCharactersViewModel: some FilterCharactersViewModel {
        return FilterCharactersViewModelImpl()
    }

    var characterDetailsViewModel: some CharacterDetailsViewModel {
        return CharacterDetailsViewModelImpl()
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

    var charactersRemoteDataSource: some CharactersRemoteDataSource {
        return GraphQLCharactersDataSource(apolloClient: apolloClient)
    }

    var charactersLocalDataSource: some CharactersLocalDataSource {
        return CoreDataCharactersDataSource(context: coreDataManagedObjectContext)
    }

    var characterDetailRemoteDataSource: some CharacterDetailRemoteDataSource {
        return GraphQLCharacterDetailDataSource(apolloClient: apolloClient)
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

    // MARK: - Core Data
    var coreDataPersistentContainer: NSPersistentContainer {
        return shared {
            guard let managedObjectModel = NSManagedObjectModel.mergedModel(from: [.main]) else {
                fatalError("Failed to create CoreData NSManagedObjectModel")
            }
            let container = NSPersistentContainer(name: "DBSchema", managedObjectModel: managedObjectModel)
            if let storeDescription = container.persistentStoreDescriptions.first {
                storeDescription.shouldAddStoreAsynchronously = true
                storeDescription.url = URL(fileURLWithPath: "/dev/null")
                storeDescription.shouldAddStoreAsynchronously = false
            }
            container.loadPersistentStores { _, error in
                if let error = error {
                    fatalError("Unable to load persistent store: \(error)")
                }
            }
            return container
        }
    }

    var coreDataManagedObjectContext: NSManagedObjectContext {
        return shared {
            let context = coreDataPersistentContainer.newBackgroundContext()
            context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            return context
        }
    }
}
