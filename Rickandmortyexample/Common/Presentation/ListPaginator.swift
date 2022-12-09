import RxSwift

class ListPaginator<TItem, TPayload> {
    private let fetchHandler: IntentHandler
    private let refetchHandler: IntentHandler
    private let fetchNextPageHandler: IntentHandler
    private var subscription: Disposable? = .none

    private let intentsSubject = PublishSubject<Intent>()

    private var refetchContinuation: CheckedContinuation<(), Never>?
    private var fetchNextPageContinuation: CheckedContinuation<(), Never>?

    init(
        fetchHandler: IntentHandler,
        refetchHandler: IntentHandler,
        fetchNextPageHandler: IntentHandler
    ) {
        self.fetchHandler = fetchHandler
        self.refetchHandler = refetchHandler
        self.fetchNextPageHandler = fetchNextPageHandler
    }

    func start() {
        subscription = intentsSubject
            .observe(on: MainScheduler.instance)
            .concatMap { [weak self] in
                self?.handleIntent(intent: $0) ?? .empty()
            }
            .subscribe(onNext: { [weak self] in
                self?.handleIntentResult(intentResult: $0)
            })
    }

    func fetchIntent(with payload: TPayload) {
        intentsSubject.onNext(.fetch(payload))
    }

    func refetchIntent() async {
        return await withCheckedContinuation { continuation in
            Task {
                await MainActor.run {
                    intentsSubject.onNext(.refetch)
                    self.refetchContinuation = continuation
                }
            }
        }
    }

    func fetchNextPageIntent() async {
        return await withCheckedContinuation { continuation in
            Task {
                await MainActor.run {
                    intentsSubject.onNext(.fetchNextPage)
                    self.fetchNextPageContinuation = continuation
                }
            }
        }
    }

    private func handleIntent(intent: Intent) -> Observable<IntentResult> {
        return .create { observer in
            switch intent {
            case .fetch(let payload): self.fetchHandler.onReceive(observer, payload)
            case .refetch: self.refetchHandler.onReceive(observer, .none)
            case .fetchNextPage: self.fetchNextPageHandler.onReceive(observer, .none)
            }

            return Disposables.create()
        }.take(1)
    }

    private func handleIntentResult(intentResult: IntentResult) {
        switch intentResult {
        case .fetch(let result): self.fetchHandler.onResult(result)
        case .refetch(let result):
            refetchHandler.onResult(result)
            refetchContinuation?.resume(returning: ())
            refetchContinuation = .none
        case .fetchNextPage(let result):
            fetchNextPageHandler.onResult(result)
            fetchNextPageContinuation?.resume(returning: ())
            fetchNextPageContinuation = .none
        }
    }

    enum Intent {
        case fetch(TPayload)
        case refetch
        case fetchNextPage
    }

    enum IntentResult {
        case fetch(Result<PaginatedResponse<TItem>, Error>)
        case refetch(Result<PaginatedResponse<TItem>, Error>)
        case fetchNextPage(Result<PaginatedResponse<TItem>, Error>)
    }

    class IntentHandler {
        fileprivate let onReceive: (_: AnyObserver<IntentResult>, _: TPayload?) -> Void
        fileprivate let onResult: (_: Result<PaginatedResponse<TItem>, Error>) -> Void

        init(
            onReceive: @escaping (_: AnyObserver<IntentResult>, _: TPayload?) -> Void,
            onResult: @escaping (_: Result<PaginatedResponse<TItem>, Error>) -> Void
        ) {
            self.onReceive = onReceive
            self.onResult = onResult
        }
    }
}
