import RxSwift

class ShowLocationsViewModelImpl: ShowLocationsViewModel {
    private let locationsRepository: LocationsRepository
    private let filterRepository: LocationFilterRepository
    private let disposeBag = DisposeBag()

    @Published var listState: NetworkData<PaginatedResponse<LocationSummary>> = .loading
    @Published var error: Error? = .none

    @Published private var filter = LocationFilter()
    var hasFilters: Bool { !filter.isEmpty }

    private var refetchContinuation: CheckedContinuation<(), Never>?
    private var fetchNextPageContinuation: CheckedContinuation<(), Never>?

    private let actionsSubject = PublishSubject<Action>()

    init(locationsRepository: LocationsRepository, filterRepository: LocationFilterRepository) {
        self.locationsRepository = locationsRepository
        self.filterRepository = filterRepository
    }

    func onViewMount() {
        filterRepository.getLatestFilterObservable()
            .subscribe(onNext: { [weak self] in
                self?.actionsSubject.onNext(.fetch($0))
            })
            .disposed(by: disposeBag)

        actionsSubject
            .observe(on: MainScheduler.instance)
            .concatMap { [weak self] in
                self?.handleAction(action: $0) ?? .empty()
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.handleActionResult(actionResult: $0)
            })
            .disposed(by: disposeBag)
    }

    @Sendable func refetch() async {
        return await withCheckedContinuation { continuation in
            Task {
                await MainActor.run {
                    actionsSubject.onNext(.refetch)
                    self.refetchContinuation = continuation
                }
            }
        }
    }

    func fetchNextPage() async {
        return await withCheckedContinuation { continuation in
            Task {
                await MainActor.run {
                    actionsSubject.onNext(.fetchNextPage)
                    self.fetchNextPageContinuation = continuation
                }
            }
        }
    }

    private func handleFetchAction(filter: LocationFilter, observer: AnyObserver<ActionResult>) {
        self.filter = filter

        Task {
            let result = await self.locationsRepository.fetch(filter: filter)
            observer.onNext(.fetch(result))
        }
    }

    private func handleFetchActionResult(result: Result<PaginatedResponse<LocationSummary>, Error>) {
        guard let result = result.unwrap() else {
            listState = .error(result.failure()!.message)
            return
        }

        listState = .data(result)
    }

    private func handleRefetchAction(observer: AnyObserver<ActionResult>) {
        Task {
            let result = await self.locationsRepository.refetch(filter: self.filter)
            observer.onNext(.refetch(result))
        }
    }

    private func handleRefetchActionResult(result: Result<PaginatedResponse<LocationSummary>, Error>) {
        defer {
            refetchContinuation?.resume(returning: ())
            refetchContinuation = .none
        }

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

    private func handleFetchNextPageAction(observer: AnyObserver<ActionResult>) {
        Task {
            guard case let .data(list) = self.listState else { return }
            let result = await self.locationsRepository.fetchNextPage(
                filter: self.filter,
                listSize: UInt32(list.items.count)
            )
            observer.onNext(.fetchNextPage(result))
        }
    }

    private func handleFetchNextPageActionResult(result: Result<PaginatedResponse<LocationSummary>, Error>) {
        defer {
            fetchNextPageContinuation?.resume(returning: ())
            fetchNextPageContinuation = .none
        }

        guard let result = result.unwrap() else {
            error = result.failure()!
            return
        }

        guard case let .data(list) = self.listState else { return }

        listState = .data(PaginatedResponse(items: list.items + result.items, hasNext: result.hasNext))
    }

    private func handleAction(action: Action) -> Observable<ActionResult> {
        return .create { observer in
            switch action {
            case .fetch(let filter): self.handleFetchAction(filter: filter, observer: observer)
            case .refetch: self.handleRefetchAction(observer: observer)
            case .fetchNextPage: self.handleFetchNextPageAction(observer: observer)
            }

            return Disposables.create()
        }.take(1)
    }

    private func handleActionResult(actionResult: ActionResult) {
        switch actionResult {
        case .fetch(let result): handleFetchActionResult(result: result)
        case .refetch(let result): handleRefetchActionResult(result: result)
        case .fetchNextPage(let result): handleFetchNextPageActionResult(result: result)
        }
    }
}

// MARK: - Types
extension ShowLocationsViewModelImpl {
    enum Action {
        case fetch(LocationFilter)
        case refetch
        case fetchNextPage
    }

    enum ActionResult {
        case fetch(Result<PaginatedResponse<LocationSummary>, Error>)
        case refetch(Result<PaginatedResponse<LocationSummary>, Error>)
        case fetchNextPage(Result<PaginatedResponse<LocationSummary>, Error>)
    }
}

// MARK: - Protocol
protocol ShowLocationsViewModel: ObservableObject {
    var listState: NetworkData<PaginatedResponse<LocationSummary>> { get }
    var hasFilters: Bool { get }
    var error: Error? { get set }

    func onViewMount()
    @Sendable func refetch() async
    func fetchNextPage() async
}
