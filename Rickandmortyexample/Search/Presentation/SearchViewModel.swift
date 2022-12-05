import SwiftUI

class SearchViewModelImpl: SearchViewModel {
    @Published var suggestions: [String] = []

    let autocompleteRepository: AutocompleteRepository

    init(autocompleteRepository: AutocompleteRepository) {
        self.autocompleteRepository = autocompleteRepository
    }

    func search(text: String) {
        Task {
            let suggestions = await self.autocompleteRepository.getAutocompletions(search: text)

            guard let suggestions = suggestions.unwrap() else { return }
            await MainActor.run {
                self.suggestions = suggestions
            }
        }
    }
}

// MARK: - Protocol
protocol SearchViewModel: ObservableObject {
    func search(text: String)

    var suggestions: [String] { get }
}
