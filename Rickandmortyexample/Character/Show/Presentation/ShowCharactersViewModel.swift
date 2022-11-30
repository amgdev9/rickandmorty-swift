import RxSwift

class ShowCharactersViewModelImpl: ShowCharactersViewModel {
    private let charactersRepository: CharactersRepository
    private let filterRepository: CharacterFilterRepository
    private let disposeBag = DisposeBag()

    @Published var listState: NetworkData<[CharacterSummary]> = .loading
    @Published var hasFilters = false
    @Published var error: Error? = .none

    init(charactersRepository: CharactersRepository, filterRepository: CharacterFilterRepository) {
        self.charactersRepository = charactersRepository
        self.filterRepository = filterRepository
    }

    func onViewMount() {
        filterRepository.getLatestFilterObservable()
            .subscribe(onNext: {
                print("\($0.name)")
            })
            .disposed(by: disposeBag)

        charactersRepository.observable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                switch $0 {
                case .failure(let error):
                    self.listState = .error(error.message)
                case .success(let characters):
                    print("Got \(characters.count)")
                    self.listState = .data(characters)
                }
            })
            .disposed(by: disposeBag)

        Task {
            let result = await charactersRepository.fetch()
            if let error = result.failure() {
                await MainActor.run {
                    self.listState = .error(error.message)
                }
            }
        }
    }

    @Sendable func refetch() async {
        let result = await charactersRepository.refetch()
        if let error = result.failure() {
            await MainActor.run {
                if case .data = listState {
                    self.error = error
                }
            }
        }
    }

    func loadNextPage() async {
        let result = await charactersRepository.loadNextPage()
        if let error = result.failure() {
            await MainActor.run {
                self.error = error
            }
        }
    }
}

// MARK: - Protocol
protocol ShowCharactersViewModel: ObservableObject {
    var listState: NetworkData<[CharacterSummary]> { get }
    var hasFilters: Bool { get }
    var error: Error? { get set }

    func onViewMount()
    @Sendable func refetch() async
    func loadNextPage() async
}
