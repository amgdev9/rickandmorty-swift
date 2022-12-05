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

    var realm: RealmComponent {
        return shared { RealmComponent(parent: self) }
    }

    var characters: CharactersComponent {
        return shared { CharactersComponent(parent: self) }
    }

    var locations: LocationsComponent {
        return shared { LocationsComponent(parent: self) }
    }

    var episodes: EpisodesComponent {
        return shared { EpisodesComponent(parent: self) }
    }

    var search: SearchComponent {
        return shared { SearchComponent(parent: self) }
    }
}
