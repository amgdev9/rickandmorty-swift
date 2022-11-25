class LocationFilter {
    var name: String
    var type: String
    var dimension: String

    init(name: String = "", type: String = "", dimension: String = "") {
        self.name = name
        self.type = type
        self.dimension = dimension
    }

    var isEmpty: Bool {
        return name.isEmpty && type.isEmpty && dimension.isEmpty
    }
}
