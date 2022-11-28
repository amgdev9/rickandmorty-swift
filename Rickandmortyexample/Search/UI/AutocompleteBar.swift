import SwiftUI
import RxSwift

struct AutocompleteBar: ViewModifier {
    @Binding var searchText: String
    let autocompletions: [String]
    let onAutocomplete: (_ search: String) -> Void

    @State private var searchTextSubject = PublishSubject<String>()
    @State private var disposeBag = DisposeBag()

    func body(content: Content) -> some View {
        content
            .searchable(text: $searchText) {
                ForEach(autocompletions, id: \.self) { autocompletion in
                    Text(autocompletion, variant: .body15).searchCompletion(autocompletion)
                }
            }
            .onAppear(perform: onMount)
            .onChange(of: searchText, perform: onSearchTextChange)
    }
}

extension View {
    func autocompleteBar(searchText: Binding<String>, autocompletions: [String], onAutocomplete: @escaping (_ search: String) -> Void) -> some View {
        modifier(AutocompleteBar(searchText: searchText, autocompletions: autocompletions, onAutocomplete: onAutocomplete))
    }
}

// MARK: - Logic
extension AutocompleteBar {
    func onMount() {
        searchTextSubject
            .debounce(.seconds(2), scheduler: MainScheduler.instance)
            .subscribe {
                onAutocomplete($0)
            }
            .disposed(by: disposeBag)
    }

    func onSearchTextChange(search: String) {
        searchTextSubject.onNext(search)
    }
}
