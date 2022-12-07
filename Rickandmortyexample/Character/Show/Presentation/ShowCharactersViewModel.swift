import RxSwift

class ShowCharactersViewModelImpl: ShowCharactersViewModel {
    private let charactersRepository: CharactersRepository
    private let filterRepository: CharacterFilterRepository
    private let disposeBag = DisposeBag()

    @Published var listState: NetworkData<PaginatedResponse<CharacterSummary>> = .loading
    @Published var error: Error? = .none

    @Published private var filter = CharacterFilter()
    var hasFilters: Bool { !filter.isEmpty }

    typealias Paginator = ListPaginator<CharacterSummary, CharacterFilter>
    private var listPaginator: Paginator? = .none

    init(charactersRepository: CharactersRepository, filterRepository: CharacterFilterRepository) {
        self.charactersRepository = charactersRepository
        self.filterRepository = filterRepository
    }

    func onViewMount() {
        filterRepository.getLatestFilterObservable()
            .subscribe(onNext: { [weak self] in
                self?.listPaginator?.fetchIntent(with: $0)
            })
            .disposed(by: disposeBag)

        let fetchHandler = ListPaginator.IntentHandler(
            onReceive: handleFetchAction,
            onResult: handleFetchActionResult
        )
        let refetchHandler = ListPaginator.IntentHandler(
            onReceive: handleRefetchAction,
            onResult: handleRefetchActionResult
        )
        let fetchNextPageHandler = ListPaginator.IntentHandler(
            onReceive: handleFetchNextPageAction,
            onResult: handleFetchNextPageActionResult
        )
        listPaginator = ListPaginator(
            fetchHandler: fetchHandler, refetchHandler: refetchHandler,
            fetchNextPageHandler: fetchNextPageHandler
        )
        listPaginator?.start()
    }

    @Sendable func refetch() async {
        await listPaginator?.refetchIntent()
    }

    func fetchNextPage() async {
        await listPaginator?.fetchNextPageIntent()
    }

    private func handleFetchAction(observer: AnyObserver<Paginator.IntentResult>, filter: CharacterFilter?) {
        guard let filter = filter else { return }
        self.filter = filter

        Task {
            let result = await self.charactersRepository.fetch(filter: filter)
            observer.onNext(.fetch(result))
        }
    }

    private func handleFetchActionResult(result: Result<PaginatedResponse<CharacterSummary>, Error>) {
        guard let result = result.unwrap() else {
            listState = .error(result.failure()!.message)
            return
        }

        listState = .data(result)
    }

    private func handleRefetchAction(observer: AnyObserver<Paginator.IntentResult>, _: CharacterFilter?) {
        Task {
            let result = await self.charactersRepository.refetch(filter: self.filter)
            observer.onNext(.refetch(result))
        }
    }

    private func handleRefetchActionResult(result: Result<PaginatedResponse<CharacterSummary>, Error>) {
        guard let result = result.unwrap() else {
            if case .error = listState {
                listState = .error(result.failure()!.message)
            } else {
                error = result.failure()!
            }
            return
        }

        listState = .data(result)
    }

    private func handleFetchNextPageAction(observer: AnyObserver<Paginator.IntentResult>, _: CharacterFilter?) {
        Task {
            guard case let .data(list) = self.listState else { return }
            let result = await self.charactersRepository.fetchNextPage(
                filter: self.filter,
                listSize: UInt32(list.items.count)
            )
            observer.onNext(.fetchNextPage(result))
        }
    }

    private func handleFetchNextPageActionResult(result: Result<PaginatedResponse<CharacterSummary>, Error>) {
        guard let result = result.unwrap() else {
            error = result.failure()!
            return
        }

        guard case let .data(list) = self.listState else { return }

        listState = .data(PaginatedResponse(items: list.items + result.items, hasNext: result.hasNext))
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
