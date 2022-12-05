import SwiftUI
import RxSwift

struct AutocompleteBar: View {
    let autocompletions: [String]
    let onAutocomplete: (_ search: String) -> Void
    let onSubmit: (_ value: String) -> Void

    @State private var searchText: String
    @State private var searchTextSubject = PublishSubject<String>()
    @State private var disposeBag = DisposeBag()
    @State private var isFocused = false

    init(initialSearchText: String,
         autocompletions: [String],
         onAutocomplete: @escaping (_: String) -> Void,
         onSubmit: @escaping (_: String) -> Void) {
        self.autocompletions = autocompletions
        self.onAutocomplete = onAutocomplete
        self.onSubmit = onSubmit
        _searchText = State(initialValue: initialSearchText)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            input {
                if !isFocused { searchIcon() }
                TextField(String(localized: "form/search"), text: $searchText, onEditingChanged: {
                    isFocused = $0
                })
                .accentColor(.gray40)
                .onSubmit {
                    onSubmit(searchText)
                }
                if !searchText.isEmpty {
                    cancelButton {
                        searchText = ""
                    }
                }
            }
            ScrollView {
                ForEach(autocompletions, id: \.self) { autocompletion in
                    autocompleteItem(autocompletion) {
                        searchText = autocompletion
                    }
                }
            }
        }
        .onMount(perform: onMount)
        .onChange(of: searchText, perform: onSearchTextChange)
    }
}

// MARK: - Styles
extension AutocompleteBar {
    func autocompleteItem(_ text: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(text, variant: .body15)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 12)
                .border(width: 1, edges: [.bottom], color: .black20)
        }
    }

    func input<Content: View>(@ViewBuilder content: @escaping () -> Content) -> some View {
        HStack(spacing: 0, content: content)
            .padding(.vertical, 8)
            .padding(.horizontal, 10)
            .background(Color.inputGray)
            .cornerRadius(10)
            .animation(Animation.default.speed(1))
    }

    func searchIcon() -> some View {
        Image(systemName: "magnifyingglass")
            .resizable()
            .frame(width: 14, height: 14)
            .foregroundColor(.gray40)
            .padding(.trailing, 8)
    }

    func cancelButton(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: "multiply.circle.fill")
                .resizable()
                .frame(width: 14, height: 14)
                .foregroundColor(.gray40)
        }
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

// MARK: - Previews
struct AutocompleteBarPreviews: PreviewProvider {
    static var previews: some View {
        AutocompleteBar(
            initialSearchText: "Hello",
            autocompletions: ["Rick", "Morty"],
            onAutocomplete: { _ in },
            onSubmit: { _ in })
            .padding(.horizontal, 16)
    }
}
