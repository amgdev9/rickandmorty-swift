import NeedleFoundation
import Apollo

class MainContainer: BootstrapComponent {
    var apolloClient: ApolloClient {
        return shared { ApolloClient(url: URL(string: ProcessInfo.processInfo.environment["SERVER_URL"]!)!) }
    }

    var showCharactersViewModel: ShowCharactersViewModel {
        return ShowCharactersViewModel()
    }
}
