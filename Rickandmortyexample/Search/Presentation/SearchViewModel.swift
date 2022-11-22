import SwiftUI

class SearchViewModelImpl: SearchViewModel {
    @Published var searchText = ""
}

// MARK: - Protocol
protocol SearchViewModel: ObservableObject {
    var searchText: String { get set }
}
