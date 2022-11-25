import SwiftUI

struct LocationList: View {
    let data: NetworkData<[LocationSummary]>
    let onRefetch: @Sendable () async -> Void
    let onLoadNextPage: () async -> Void
    let onPress: (_ id: String) -> Void

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        PaginatedList(data: data, onRefetch: onRefetch, onLoadNextPage: onLoadNextPage) { items in
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(items, id: \.id) { item in
                    LocationCard(location: item, onPress: onPress)
                        .frame(maxWidth: UIScreen.width * 0.42)
                }
            }.padding(.top, 20)
        }
    }
}

// MARK: - Previews
struct LocationListPreviews: PreviewProvider {
    static let locations = (1...10).map { i in
        LocationSummary.Builder()
            .set(id: String(i))
            .set(name: "Earth (C-137)")
            .set(type: "Planet")
            .build()
    }

    static var previews: some View {
        LocationList(data: .data(locations), onRefetch: delay, onLoadNextPage: delay, onPress: { _ in })
    }
}
