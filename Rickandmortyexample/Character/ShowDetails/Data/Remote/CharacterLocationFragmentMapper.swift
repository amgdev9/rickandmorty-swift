extension CharacterLocationFragment {
    func toDomain() -> CharacterLocation {
        return CharacterLocation(id: id ?? "", name: name ?? "")
    }
}
