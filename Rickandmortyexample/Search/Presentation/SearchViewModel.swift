import SwiftUI

class SearchViewModelImpl: SearchViewModel {
    @Published var suggestions: [String] = []

    let autocompleteRepository: AutocompleteRepository

    init(autocompleteRepository: AutocompleteRepository) {
        self.autocompleteRepository = autocompleteRepository
    }

    func search(text: String) {
        Task {
            let result = await autocompleteRepository.getAutocompletions(search: text)

            guard let result = result.unwrap() else { return }
            await MainActor.run {
                suggestions = result
            }
        }
    }
}

// MARK: - Protocol
protocol SearchViewModel: ObservableObject {
    func search(text: String)

    var suggestions: [String] { get }
}
