import RxSwift

class ShowEpisodesViewModelImpl: ShowEpisodesViewModel {
    private let episodesRepository: EpisodesRepository
    private let filterRepository: EpisodeFilterRepository
    private let disposeBag = DisposeBag()

    @Published var listState: NetworkData<PaginatedResponse<EpisodeSeason>> = .loading
    @Published var error: Error? = .none

    @Published private var filter = EpisodeFilter()
    var hasFilters: Bool { !filter.isEmpty }

    typealias Paginator = ListPaginator<EpisodeSummary, EpisodeFilter>
    private var listPaginator: Paginator? = .none

    init(episodesRepository: EpisodesRepository, filterRepository: EpisodeFilterRepository) {
        self.episodesRepository = episodesRepository
        self.filterRepository = filterRepository
    }

    func onViewMount() {
        filterRepository.getLatestFilterObservable()
            .subscribe(onNext: { [weak self] in
                self?.listPaginator?.fetchIntent(with: $0)
            })
            .disposed(by: disposeBag)

        let fetchHandler = Paginator.IntentHandler(
            onReceive: { [weak self] observer, filter in
                guard let filter = filter else { return }
                self?.handleFetchAction(observer: observer, filter: filter)
            },
            onResult: { [weak self] result in
                self?.handleFetchActionResult(result: result)
            }
        )
        let refetchHandler = Paginator.IntentHandler(
            onReceive: { [weak self] observer, _ in
                self?.handleRefetchAction(observer: observer)
            },
            onResult: { [weak self] result in
                self?.handleRefetchActionResult(result: result)
            }
        )
        let fetchNextPageHandler = Paginator.IntentHandler(
            onReceive: { [weak self] observer, _ in
                self?.handleFetchNextPageAction(observer: observer)
            },
            onResult: { [weak self] result in
                self?.handleFetchNextPageActionResult(result: result)
            }
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

    private func handleFetchAction(observer: AnyObserver<Paginator.IntentResult>, filter: EpisodeFilter) {
        self.filter = filter

        Task {
            let result = await self.episodesRepository.fetch(filter: filter)
            observer.onNext(.fetch(result))
        }
    }

    private func episodesToSeasons(episodes: [EpisodeSummary]) -> [EpisodeSeason] {
        let seasons: [EpisodeSeason] = Dictionary(grouping: episodes, by: {
            UInt16($0.seasonId.slice(from: "S", to: "E")!)!
        }).map { key, episodes in
            EpisodeSeason(id: key, episodes: episodes)
        }.sorted(by: { lhs, rhs in
            lhs.episodes.first!.seasonId < rhs.episodes.first!.seasonId
        })

        return seasons
    }

    private func handleFetchActionResult(result: Result<PaginatedResponse<EpisodeSummary>, Error>) {
        guard let result = result.unwrap() else {
            listState = .error(result.failure()!.message)
            return
        }

        let seasons = episodesToSeasons(episodes: result.items)

        listState = .data(PaginatedResponse(items: seasons, hasNext: result.hasNext))
    }

    private func handleRefetchAction(observer: AnyObserver<Paginator.IntentResult>) {
        Task {
            let result = await self.episodesRepository.refetch(filter: self.filter)
            observer.onNext(.refetch(result))
        }
    }

    private func handleRefetchActionResult(result: Result<PaginatedResponse<EpisodeSummary>, Error>) {
        guard let result = result.unwrap() else {
            if case .error = listState {
                listState = .error(result.failure()!.message)
            } else {
                error = result.failure()!
            }
            return
        }

        let seasons = episodesToSeasons(episodes: result.items)

        listState = .data(PaginatedResponse(items: seasons, hasNext: result.hasNext))
    }

    private func handleFetchNextPageAction(observer: AnyObserver<Paginator.IntentResult>) {
        Task {
            guard case let .data(list) = self.listState else { return }
            let listSize = list.items.map { $0.episodes.count }.reduce(0, +)
            let result = await self.episodesRepository.fetchNextPage(
                filter: self.filter,
                listSize: UInt32(listSize)
            )
            observer.onNext(.fetchNextPage(result))
        }
    }

    private func mergeSeasons(oldSeasons: [EpisodeSeason], newSeasons: [EpisodeSeason]) -> [EpisodeSeason] {
        let lastSeasonId = oldSeasons.last?.id
        guard let lastSeasonId = lastSeasonId else { return newSeasons }

        let firstNewSeasonId = newSeasons.first?.id
        guard let firstNewSeasonId = firstNewSeasonId else { return oldSeasons }

        if lastSeasonId == firstNewSeasonId {
            var result = Array(oldSeasons.dropLast(1))
            let mergedSeason = EpisodeSeason(
                id: oldSeasons.last!.id,
                episodes: oldSeasons.last!.episodes + newSeasons.first!.episodes
            )
            result.append(mergedSeason)
            result.append(contentsOf: newSeasons.dropFirst(1))
            return result
        } else {
            return oldSeasons + newSeasons
        }
    }

    private func handleFetchNextPageActionResult(result: Result<PaginatedResponse<EpisodeSummary>, Error>) {
        guard let result = result.unwrap() else {
            error = result.failure()!
            return
        }

        guard case let .data(list) = self.listState else { return }

        let seasons = episodesToSeasons(episodes: result.items)

        listState = .data(
            PaginatedResponse(items: mergeSeasons(oldSeasons: list.items, newSeasons: seasons), hasNext: result.hasNext)
        )
    }
}

// MARK: - Protocol
protocol ShowEpisodesViewModel: ObservableObject {
    var listState: NetworkData<PaginatedResponse<EpisodeSeason>> { get }
    var hasFilters: Bool { get }
    var error: Error? { get set }

    func onViewMount()
    @Sendable func refetch() async
    func fetchNextPage() async
}
