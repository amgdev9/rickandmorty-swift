import SwiftUI

class SearchViewModelImpl: SearchViewModel {
    @Published var searchText = ""
    @Published var suggestions: [String] = []

    func search(text: String) {
        // TODO
    }
}

// MARK: - Protocol
protocol SearchViewModel: ObservableObject {
    func search(text: String)

    var searchText: String { get set }
    var suggestions: [String] { get }
}
