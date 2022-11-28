class PaginatedResponse<Item> {
    let numPages: UInt32
    let items: [Item]

    init(numPages: UInt32, items: [Item]) {
        self.numPages = numPages
        self.items = items
    }
}
