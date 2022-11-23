import SwiftUI

struct NetworkDataContainer<Data, Content>: View where Content: View {
    let data: NetworkData<Data>
    let onRefetch: @Sendable () async -> Void
    @ViewBuilder let content: (_: Data) -> Content

    @State private var loadingRefetch = false

    var body: some View {
        VStack {
            switch data {
            case .loading:
                ProgressView()
            case .error(let message):
                ErrorState(message: message, loading: loadingRefetch, onPress: handleRefetch)
            case .data(let loadedData):
                    content(loadedData)
                        .refreshable(action: onRefetch)
            }
        }
    }
}

// MARK: - Logic
extension NetworkDataContainer {
    @Sendable func handleRefetch() {
        loadingRefetch = true
        Task { @MainActor in
            await onRefetch()
            loadingRefetch = false
        }
    }
}

// MARK: - Previews
struct NetworkDataContainerPreviews: PreviewProvider {
    @Sendable static func delay() async {
        try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
    }

    static var previews: some View {
        NetworkDataContainer(data: NetworkData<String>.loading, onRefetch: delay) { _ in }
            .previewDisplayName("Loading state")
        NetworkDataContainer(data: NetworkData<String>.error("An error happened!"), onRefetch: delay) { _ in }
            .previewDisplayName("Error state")
        NetworkDataContainer(data: NetworkData.data("Loaded data"), onRefetch: delay) { data in
            ScrollView {
                Text(data, variant: .body15)
            }
        }
        .previewDisplayName("Success state")
    }
}
