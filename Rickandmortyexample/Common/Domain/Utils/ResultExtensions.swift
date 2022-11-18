extension Result {
    func unwrap() -> Success? {
        switch self {
        case .success(let value): return .some(value)
        case .failure: return .none
        }
    }

    func failure() -> Failure? {
        switch self {
        case .success: return .none
        case .failure(let error): return .some(error)
        }
    }
}
