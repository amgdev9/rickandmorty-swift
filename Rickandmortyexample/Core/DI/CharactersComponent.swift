import NeedleFoundation

protocol CharactersDependencies: Dependency {
    var apolloClient: ApolloClient { get }
    var realm: RealmComponent { get }
}

class CharactersComponent: Component<CharactersDependencies> {
    var showCharactersViewModel: some ShowCharactersViewModel {
        return ShowCharactersViewModelImpl(
            charactersRepository: charactersRepository,
            filterRepository: characterFilterRepository
        )
    }

    var charactersRepository: some CharactersRepository {
        return shared {
            CharactersRepositoryImpl(
                remoteDataSource: charactersRemoteDataSource,
                localDataSource: charactersLocalDataSource
            )
        }
    }

    var characterFilterRepository: some CharacterFilterRepository {
        return shared {
            RealmCharacterFilterRepository(
                realmFactory: dependency.realm.realmFactory,
                realmQueue: dependency.realm.realmQueue
            )
        }
    }

    var filterCharactersViewModel: some FilterCharactersViewModel {
        return FilterCharactersViewModelImpl(
            characterFilterRepository: characterFilterRepository
        )
    }

    var characterDetailsRepository: some CharacterDetailsRepository {
        return shared {
            CharacterDetailsRepositoryImpl(
                remoteDataSource: characterDetailRemoteDataSource,
                localDataSource: characterDetailLocalDataSource
            )
        }
    }

    var characterDetailRemoteDataSource: some CharacterDetailRemoteDataSource {
        return GraphQLCharacterDetailDataSource(apolloClient: dependency.apolloClient)
    }

    var characterDetailLocalDataSource: some CharacterDetailsLocalDataSource {
        return RealmCharacterDetailsDataSource(
            realmFactory: dependency.realm.realmFactory,
            realmQueue: dependency.realm.realmQueue
        )
    }

    var charactersRemoteDataSource: some CharactersRemoteDataSource {
        return GraphQLCharactersDataSource(apolloClient: dependency.apolloClient)
    }

    var charactersLocalDataSource: some CharactersLocalDataSource {
        return RealmCharactersDataSource(
            realmFactory: dependency.realm.realmFactory,
            realmQueue: dependency.realm.realmQueue
        )
    }

    var characterDetailsViewModel: some CharacterDetailsViewModel {
        return CharacterDetailsViewModelImpl(
            characterDetailsRepository: characterDetailsRepository
        )
    }
}
