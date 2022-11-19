import NeedleFoundation
import Apollo
import CoreData

class MainContainer: BootstrapComponent {
    var configuration: some Configuration {
        return shared { IOSConfiguration() }
    }

    var apolloClient: ApolloClient {
        return shared { ApolloClient(url: configuration.serverUrl) }
    }

    // MARK: - View Models
    var showCharactersViewModel: some ShowCharactersViewModel {
        return SwiftUIShowCharactersViewModel(charactersRepository: charactersRepository)
    }

    var showLocationsViewModel: ShowLocationsViewModel {
        return ShowLocationsViewModel()
    }

    var showEpisodesViewModel: ShowEpisodesViewModel {
        return ShowEpisodesViewModel()
    }

    var filterCharactersViewModel: FilterCharactersViewModel {
        return FilterCharactersViewModel()
    }

    var characterDetailsViewModel: CharacterDetailsViewModel {
        return CharacterDetailsViewModel()
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

                container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
            }
            return container
        }
    }

    var coreDataManagedObjectContext: NSManagedObjectContext {
        return shared {
            coreDataPersistentContainer.newBackgroundContext()
        }
    }
}
