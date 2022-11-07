import SwiftUI

struct ContentView: View {

    @State private var currentTab: TabID = .character

    let apolloClient = ApolloClient(url: URL(string: "https://rickandmortyapi.com/graphql")!)

    var body: some View {
        VStack(spacing: 0) {
            Color.white.ignoresSafeArea(edges: [.top])
            Tabs(currentTab: $currentTab)
        }.onAppear {
            apolloClient.fetch(query: CharactersQuery()) { result in
                switch result {
                case .success(let graphQLResult):
                    if let name = graphQLResult.data?.characters?.results?[0]?.name {
                        print(name) // Luke Skywalker
                    } else if let errors = graphQLResult.errors {
                        // GraphQL errors
                        print(errors)
                    }
                case .failure(let error):
                    // Network or response format errors
                    print("Network error")
                    print(error.localizedDescription)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
