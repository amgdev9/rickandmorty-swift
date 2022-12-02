import RxSwift

class CharacterDetailsViewModelImpl: CharacterDetailsViewModel {
    private var characterDetailsRepository: CharacterDetailsRepository
    private let disposeBag = DisposeBag()

    @Published var character: NetworkData<CharacterDetails> = .loading
    @Published var error: Error? = .none

    var characterId: String? = .none

    init(characterDetailsRepository: CharacterDetailsRepository) {
        self.characterDetailsRepository = characterDetailsRepository
    }

    func onViewMount(characterId: String) {
        self.characterId = characterId
        characterDetailsRepository.getObservable(id: characterId)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                guard let details = $0.unwrap() else {
                    self.character = .error($0.failure()!.message)
                    return
                }

                self.character = .data(details)
            })
            .disposed(by: disposeBag)
    }

    @Sendable func refetch() async {
        guard let id = characterId else { return }
        let result = await characterDetailsRepository.refetch(id: id)

        if let error = result.failure() {
            await MainActor.run {
                if case .error = character {
                    self.character = .error(error.message)
                } else {
                    self.error = error
                }
            }
        }
    }
}

// MARK: - Protocol
protocol CharacterDetailsViewModel: ObservableObject {
    var character: NetworkData<CharacterDetails> { get }
    var error: Error? { get set }

    func onViewMount(characterId: String)
    @Sendable func refetch() async
}
