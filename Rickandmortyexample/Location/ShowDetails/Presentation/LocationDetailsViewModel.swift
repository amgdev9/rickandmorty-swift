import RxSwift

class LocationDetailsViewModelImpl: LocationDetailsViewModel {
    private var locationDetailsRepository: LocationDetailsRepository
    private let disposeBag = DisposeBag()

    @Published var location: NetworkData<LocationDetail> = .loading
    @Published var error: Error? = .none

    var locationId: String? = .none

    init(locationDetailsRepository: LocationDetailsRepository) {
        self.locationDetailsRepository = locationDetailsRepository
    }

    func onViewMount(locationId: String) {
        self.locationId = locationId
        locationDetailsRepository.getObservable(id: locationId)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let viewModel = self else { return }
                guard let detail = $0.unwrap() else {
                    viewModel.location = .error($0.failure()!.message)
                    return
                }

                viewModel.location = .data(detail)
            })
            .disposed(by: disposeBag)
    }

    @Sendable func refetch() async {
        guard let id = locationId else { return }
        let result = await locationDetailsRepository.refetch(id: id)

        if let error = result.failure() {
            await MainActor.run {
                if case .error = location {
                    self.location = .error(error.message)
                } else {
                    self.error = error
                }
            }
        }
    }
}

// MARK: - Protocol
protocol LocationDetailsViewModel: ObservableObject {
    var location: NetworkData<LocationDetail> { get }
    var error: Error? { get set }

    func onViewMount(locationId: String)
    @Sendable func refetch() async
}
