class PaginatedResponse<Items> {
    let numPages: UInt32
    let items: [Items]

    init(numPages: UInt32, items: [Items]) {
        self.numPages = numPages
        self.items = items
    }
}
