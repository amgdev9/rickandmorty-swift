import SwiftUI

struct PaginatedList<Data, Content>: View where Content: View {
    let data: NetworkData<PaginatedResponse<Data>>
    let onRefetch: @Sendable () async -> Void
    let onLoadNextPage: () async -> Void
    @ViewBuilder let content: (_: [Data]) -> Content

    @State private var loadingNextPage = false

    var body: some View {
        NetworkDataContainer(data: data, onRefetch: onRefetch) { loadedData in
            BottomDetectorScrollView {
                VStack(spacing: 0) {
                    content(loadedData.items)
                    if loadingNextPage { ProgressView().padding(16) }
                }
            } onBottomReached: {
                handleLoadNextPage()
            }
        }
    }
}

// MARK: - Logic
extension PaginatedList {
    func handleLoadNextPage() {
        if loadingNextPage { return }
        if case .data(let paginatedData) = data, !paginatedData.hasNext { return }

        loadingNextPage = true
        Task { @MainActor in
            await onLoadNextPage()
            loadingNextPage = false
        }
    }
}

// MARK: - Previews
struct PaginatedListPreviews: PreviewProvider {
    static var previews: some View {
        PaginatedList(
            data: NetworkData.data(PaginatedResponse(items: ["Hello"], hasNext: false)),
            onRefetch: PreviewUtils.delay,
            onLoadNextPage: PreviewUtils.delay) { data in
                Text(data.first!, variant: .body15)

        }
            .previewDisplayName("With data")
        PaginatedList(
            data: NetworkData<PaginatedResponse<String>>.loading,
            onRefetch: PreviewUtils.delay,
            onLoadNextPage: PreviewUtils.delay) { _ in }
            .previewDisplayName("Loading")
    }
}
