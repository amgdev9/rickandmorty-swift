extension GraphQLNullable<String> {
    static func from(_ value: String) -> Self {
        if value.isEmpty { return .none }
        return .some(value)
    }
}
