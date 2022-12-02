import RxSwift

class ShowCharactersViewModelImpl: ShowCharactersViewModel {
    private let charactersRepository: CharactersRepository
    private let filterRepository: CharacterFilterRepository
    private let disposeBag = DisposeBag()

    @Published var listState: NetworkData<PaginatedResponse<CharacterSummary>> = .loading
    @Published var error: Error? = .none

    @Published private var filter = CharacterFilter()
    var hasFilters: Bool { !filter.isEmpty }

    private var refetchContinuation: CheckedContinuation<(), Never>?
    private var fetchNextPageContinuation: CheckedContinuation<(), Never>?

    enum Action {
        case fetch(CharacterFilter)
        case refetch
        case fetchNextPage
    }

    enum ActionResult {
        case fetch(Result<PaginatedResponse<CharacterSummary>, Error>)
        case refetch(Result<PaginatedResponse<CharacterSummary>, Error>)
        case fetchNextPage(Result<PaginatedResponse<CharacterSummary>, Error>)
    }

    private let actionsSubject = PublishSubject<Action>()

    init(charactersRepository: CharactersRepository, filterRepository: CharacterFilterRepository) {
        self.charactersRepository = charactersRepository
        self.filterRepository = filterRepository
    }

    func onViewMount() {
        filterRepository.getLatestFilterObservable()
            .subscribe(onNext: {
                self.actionsSubject.onNext(.fetch($0))
            })
            .disposed(by: disposeBag)

        actionsSubject
            .map {
                print("\($0)")
                return $0
            }
            .observe(on: MainScheduler.instance)
            .concatMap(handleAction)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                self.handleActionResult(actionResult: $0)
            })
            .disposed(by: disposeBag)
    }

    @Sendable func refetch() async {
        return await withCheckedContinuation { continuation in
            actionsSubject.onNext(.refetch)
            self.refetchContinuation = continuation
        }
    }

    func fetchNextPage() async {
        return await withCheckedContinuation { continuation in
            actionsSubject.onNext(.fetchNextPage)
            self.fetchNextPageContinuation = continuation
        }
    }

    private func handleAction(action: Action) -> Observable<ActionResult> {
        switch action {
        case .fetch(let filter):
            return .create { observer in
                self.filter = filter
                Task {
                    let result = await self.charactersRepository.fetch(filter: filter)
                    observer.onNext(.fetch(result))
                }

                return Disposables.create()
            }.take(1)
        case .refetch:
            return .create { observer in
                Task {
                    let result = await self.charactersRepository.refetch(filter: self.filter)
                    observer.onNext(.fetch(result))
                }

                return Disposables.create()
            }.take(1)
        case .fetchNextPage:
            return .create { observer in
                Task {
                    guard case let .data(list) = self.listState else { return }
                    let result = await self.charactersRepository.fetchNextPage(filter: self.filter, listSize: UInt32(list.items.count))
                    observer.onNext(.fetch(result))
                }

                return Disposables.create()
            }.take(1)
        }
    }

    private func handleActionResult(actionResult: ActionResult) {
        switch actionResult {
        case .fetch(let result):
            guard let result = result.unwrap() else {
                listState = .error(result.failure()!.message)
                return
            }

            listState = .data(result)
        case .refetch(let result):
            guard let result = result.unwrap() else {
                if case .error = listState {
                    listState = .error(result.failure()!.message)
                } else {
                    error = result.failure()!
                }
                refetchContinuation?.resume(returning: ())
                refetchContinuation = .none
                return
            }

            listState = .data(result)
            refetchContinuation?.resume(returning: ())
            refetchContinuation = .none
        case .fetchNextPage(let result):
            guard let result = result.unwrap() else {
                error = result.failure()!
                fetchNextPageContinuation?.resume(returning: ())
                fetchNextPageContinuation = .none
                return
            }

            guard case let .data(list) = self.listState else { return }

            listState = .data(PaginatedResponse(items: list.items + result.items, hasNext: result.hasNext))
            fetchNextPageContinuation?.resume(returning: ())
            fetchNextPageContinuation = .none
        }
    }
}

// MARK: - Protocol
protocol ShowCharactersViewModel: ObservableObject {
    var listState: NetworkData<PaginatedResponse<CharacterSummary>> { get }
    var hasFilters: Bool { get }
    var error: Error? { get set }

    func onViewMount()
    @Sendable func refetch() async
    func fetchNextPage() async
}
