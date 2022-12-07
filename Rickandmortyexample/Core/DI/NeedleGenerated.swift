

import Apollo
import CoreData
import NeedleFoundation
import RealmSwift

// swiftlint:disable unused_declaration
private let needleDependenciesHash : String? = nil

// MARK: - Traversal Helpers

private func parent1(_ component: NeedleFoundation.Scope) -> NeedleFoundation.Scope {
    return component.parent
}

// MARK: - Providers

#if !NEEDLE_DYNAMIC

private class EpisodesDependenciescca95be2fdb171864380Provider: EpisodesDependencies {
    var apolloClient: ApolloClient {
        return mainContainer.apolloClient
    }
    var realm: RealmComponent {
        return mainContainer.realm
    }
    private let mainContainer: MainContainer
    init(mainContainer: MainContainer) {
        self.mainContainer = mainContainer
    }
}
/// ^->MainContainer->EpisodesComponent
private func factory650c9d6ac505bc5bef92135b2c90f235c08d4715(_ component: NeedleFoundation.Scope) -> AnyObject {
    return EpisodesDependenciescca95be2fdb171864380Provider(mainContainer: parent1(component) as! MainContainer)
}
private class LocationsDependenciesd88ffa0973cf770438eeProvider: LocationsDependencies {
    var apolloClient: ApolloClient {
        return mainContainer.apolloClient
    }
    var realm: RealmComponent {
        return mainContainer.realm
    }
    private let mainContainer: MainContainer
    init(mainContainer: MainContainer) {
        self.mainContainer = mainContainer
    }
}
/// ^->MainContainer->LocationsComponent
private func factoryfdcbd715e8eec8fe95d7135b2c90f235c08d4715(_ component: NeedleFoundation.Scope) -> AnyObject {
    return LocationsDependenciesd88ffa0973cf770438eeProvider(mainContainer: parent1(component) as! MainContainer)
}
private class SearchDependenciesb2a2d779edc9887ac31fProvider: SearchDependencies {
    var apolloClient: ApolloClient {
        return mainContainer.apolloClient
    }
    private let mainContainer: MainContainer
    init(mainContainer: MainContainer) {
        self.mainContainer = mainContainer
    }
}
/// ^->MainContainer->SearchComponent
private func factory00794dbba415fa6701d3135b2c90f235c08d4715(_ component: NeedleFoundation.Scope) -> AnyObject {
    return SearchDependenciesb2a2d779edc9887ac31fProvider(mainContainer: parent1(component) as! MainContainer)
}
private class CharactersDependencies16d61f119434284e8c54Provider: CharactersDependencies {
    var apolloClient: ApolloClient {
        return mainContainer.apolloClient
    }
    var realm: RealmComponent {
        return mainContainer.realm
    }
    private let mainContainer: MainContainer
    init(mainContainer: MainContainer) {
        self.mainContainer = mainContainer
    }
}
/// ^->MainContainer->CharactersComponent
private func factorybccbc03b8af291d69916135b2c90f235c08d4715(_ component: NeedleFoundation.Scope) -> AnyObject {
    return CharactersDependencies16d61f119434284e8c54Provider(mainContainer: parent1(component) as! MainContainer)
}

#else
extension EpisodesComponent: Registration {
    public func registerItems() {
        keyPathToName[\EpisodesDependencies.apolloClient] = "apolloClient-ApolloClient"
        keyPathToName[\EpisodesDependencies.realm] = "realm-RealmComponent"
    }
}
extension LocationsComponent: Registration {
    public func registerItems() {
        keyPathToName[\LocationsDependencies.apolloClient] = "apolloClient-ApolloClient"
        keyPathToName[\LocationsDependencies.realm] = "realm-RealmComponent"
    }
}
extension MainContainer: Registration {
    public func registerItems() {


    }
}
extension SearchComponent: Registration {
    public func registerItems() {
        keyPathToName[\SearchDependencies.apolloClient] = "apolloClient-ApolloClient"
    }
}
extension CharactersComponent: Registration {
    public func registerItems() {
        keyPathToName[\CharactersDependencies.apolloClient] = "apolloClient-ApolloClient"
        keyPathToName[\CharactersDependencies.realm] = "realm-RealmComponent"
    }
}
extension RealmComponent: Registration {
    public func registerItems() {

    }
}


#endif

private func factoryEmptyDependencyProvider(_ component: NeedleFoundation.Scope) -> AnyObject {
    return EmptyDependencyProvider(component: component)
}

// MARK: - Registration
private func registerProviderFactory(_ componentPath: String, _ factory: @escaping (NeedleFoundation.Scope) -> AnyObject) {
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: componentPath, factory)
}

#if !NEEDLE_DYNAMIC

private func register1() {
    registerProviderFactory("^->MainContainer->EpisodesComponent", factory650c9d6ac505bc5bef92135b2c90f235c08d4715)
    registerProviderFactory("^->MainContainer->LocationsComponent", factoryfdcbd715e8eec8fe95d7135b2c90f235c08d4715)
    registerProviderFactory("^->MainContainer", factoryEmptyDependencyProvider)
    registerProviderFactory("^->MainContainer->SearchComponent", factory00794dbba415fa6701d3135b2c90f235c08d4715)
    registerProviderFactory("^->MainContainer->CharactersComponent", factorybccbc03b8af291d69916135b2c90f235c08d4715)
    registerProviderFactory("^->MainContainer->RealmComponent", factoryEmptyDependencyProvider)
}
#endif

public func registerProviderFactories() {
#if !NEEDLE_DYNAMIC
    register1()
#endif
}
