import NeedleFoundation

protocol SearchDependencies: Dependency {
    var apolloClient: ApolloClient { get }
}

class SearchComponent: Component<SearchDependencies> {
    func searchViewModel(autocompleteRepository: some AutocompleteRepository) -> some SearchViewModel {
        return SearchViewModelImpl(autocompleteRepository: autocompleteRepository)
    }

    var autocompleteByCharacterNameRepository: some AutocompleteRepository {
        return AutocompleteByCharacterNameRepository(apolloClient: dependency.apolloClient)
    }

    var autocompleteByCharacterSpeciesRepository: some AutocompleteRepository {
        return AutocompleteByCharacterSpeciesRepository(apolloClient: dependency.apolloClient)
    }

    var autocompleteByLocationNameRepository: some AutocompleteRepository {
        return AutocompleteByLocationNameRepository(apolloClient: dependency.apolloClient)
    }

    var autocompleteByLocationTypeRepository: some AutocompleteRepository {
        return AutocompleteByLocationTypeRepository(apolloClient: dependency.apolloClient)
    }

    var autocompleteByLocationDimensionRepository: some AutocompleteRepository {
        return AutocompleteByLocationDimensionRepository(apolloClient: dependency.apolloClient)
    }

    var autocompleteByEpisodeNameRepository: some AutocompleteRepository {
        return AutocompleteByEpisodeNameRepository(apolloClient: dependency.apolloClient)
    }

    var autocompleteByEpisodeSeasonIDRepository: some AutocompleteRepository {
        return AutocompleteByEpisodeSeasonIDRepository(apolloClient: dependency.apolloClient)
    }
}
