import NeedleFoundation

protocol LocationsDependencies: Dependency {
    var apolloClient: ApolloClient { get }
    var realm: RealmComponent { get }
}

class LocationsComponent: Component<LocationsDependencies> {
    var showLocationsViewModel: some ShowLocationsViewModel {
        return ShowLocationsViewModelImpl(
            locationsRepository: locationsRepository,
            filterRepository: locationFilterRepository
        )
    }

    var locationDetailsViewModel: some LocationDetailsViewModel {
        return LocationDetailsViewModelImpl(locationDetailsRepository: locationDetailsRepository)
    }

    var locationDetailsRepository: some LocationDetailsRepository {
        return shared {
            LocationDetailsRepositoryImpl(
                remoteDataSource: locationDetailRemoteDataSource,
                localDataSource: locationDetailLocalDataSource
            )
        }
    }

    var locationsRepository: some LocationsRepository {
        return shared {
            LocationsRepositoryImpl(
                remoteDataSource: locationsRemoteDataSource,
                localDataSource: locationsLocalDataSource
            )
        }
    }

    var locationsRemoteDataSource: some LocationsRemoteDataSource {
        return GraphQLLocationsDataSource(apolloClient: dependency.apolloClient)
    }

    var locationsLocalDataSource: some LocationsLocalDataSource {
        return RealmLocationsDataSource(
            realmFactory: dependency.realm.realmFactory,
            realmQueue: dependency.realm.realmQueue
        )
    }

    var locationDetailRemoteDataSource: some LocationDetailRemoteDataSource {
        return GraphQLLocationDetailDataSource(apolloClient: dependency.apolloClient)
    }

    var locationDetailLocalDataSource: some LocationDetailLocalDataSource {
        return RealmLocationDetailDataSource(
            realmFactory: dependency.realm.realmFactory,
            realmQueue: dependency.realm.realmQueue
        )
    }

    var filterLocationsViewModel: some FilterLocationsViewModel {
        return FilterLocationsViewModelImpl(locationFilterRepository: locationFilterRepository)
    }

    var locationFilterRepository: some LocationFilterRepository {
        return shared {
            RealmLocationFilterRepository(
                realmFactory: dependency.realm.realmFactory,
                realmQueue: dependency.realm.realmQueue
            )
        }
    }
}
