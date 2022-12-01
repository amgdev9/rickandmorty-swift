class PaginatedResponse<Item> {
    let items: [Item]
    let hasNext: Bool

    init(items: [Item], hasNext: Bool) {
        self.items = items
        self.hasNext = hasNext
    }
}
