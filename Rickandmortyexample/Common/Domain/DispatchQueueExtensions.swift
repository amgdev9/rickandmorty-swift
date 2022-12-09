import RealmSwift

extension DispatchQueue {
    func runAsync<T>(_ body: @escaping (CheckedContinuation<T, Never>) -> Void) async -> T {
        return await withCheckedContinuation { continuation in
            self.async {
                body(continuation)
            }
        }
    }
}
