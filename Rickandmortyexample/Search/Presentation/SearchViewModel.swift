import SwiftUI

class SearchViewModelImpl: SearchViewModel {
    @Published var searchText = ""
    @Published var suggestions: [String] = []

    func search() {
        // TODO
    }
}

// MARK: - Protocol
protocol SearchViewModel: ObservableObject {
    var searchText: String { get set }
    var suggestions: [String] { get }

    func search()
}
