import RxSwift

class EpisodeDetailsViewModelImpl: EpisodeDetailsViewModel {
    private var episodeDetailsRepository: EpisodeDetailsRepository
    private let disposeBag = DisposeBag()

    @Published var episode: NetworkData<EpisodeDetail> = .loading
    @Published var error: Error? = .none

    var episodeId: String? = .none

    init(episodeDetailsRepository: EpisodeDetailsRepository) {
        self.episodeDetailsRepository = episodeDetailsRepository
    }

    func onViewMount(episodeId: String) {
        self.episodeId = episodeId
        episodeDetailsRepository.getObservable(id: episodeId)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let viewModel = self else { return }
                guard let details = $0.unwrap() else {
                    viewModel.episode = .error($0.failure()!.message)
                    return
                }

                viewModel.episode = .data(details)
            })
            .disposed(by: disposeBag)
    }

    @Sendable func refetch() async {
        guard let id = episodeId else { return }
        let result = await episodeDetailsRepository.refetch(id: id)

        if let error = result.failure() {
            await MainActor.run {
                if case .error = episode {
                    self.episode = .error(error.message)
                } else {
                    self.error = error
                }
            }
        }
    }
}

// MARK: - Protocol
protocol EpisodeDetailsViewModel: ObservableObject {
    var episode: NetworkData<EpisodeDetail> { get }
    var error: Error? { get set }

    func onViewMount(episodeId: String)
    @Sendable func refetch() async
}
