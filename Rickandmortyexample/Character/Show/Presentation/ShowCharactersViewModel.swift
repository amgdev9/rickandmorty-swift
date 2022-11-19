import RxSwift

class SwiftUIShowCharactersViewModel: ShowCharactersViewModel {
    private let charactersRepository: CharactersRepository
    private let disposeBag = DisposeBag()

    @Published var listState: ListState<CharacterSummary> = .loading
    @Published var hasFilters = false

    init(charactersRepository: CharactersRepository) {
        self.charactersRepository = charactersRepository
    }

    func onViewMount() {
        charactersRepository.observable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                switch $0 {
                case .failure(let error):
                    self.listState = .error(error.message)
                case .success(let characters):
                    self.listState = .data(characters)
                }
            })
            .disposed(by: disposeBag)
    }

    @Sendable func refetch() async {
        let result = await charactersRepository.refetch()
        if let error = result.failure() {
            print(error.message)
        }
    }

    func loadNextPage() async {
        let result = await charactersRepository.loadNextPage()
        if let error = result.failure() {
            print(error.message)
        }
    }
}

// MARK: - Protocol
protocol ShowCharactersViewModel: ObservableObject {
    var listState: ListState<CharacterSummary> { get }
    var hasFilters: Bool { get }

    func onViewMount()
    @Sendable func refetch() async
    func loadNextPage() async
}
