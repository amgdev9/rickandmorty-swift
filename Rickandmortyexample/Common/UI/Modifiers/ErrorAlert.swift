import SwiftUI
import AlertToast

struct ErrorAlert: ViewModifier {
    @Binding var error: Error?
    @State private var showToast = false

    func body(content: Content) -> some View {
        content
            .toast(isPresenting: $showToast, duration: 4) {
                AlertToast(displayMode: .banner(.slide), type: .error(Color.red),
                           title: String(localized: "error/alert-title"), subTitle: error?.message)
            }
            .onChange(of: showToast) { _ in
                if showToast { return }
                error = .none
            }
            .onChange(of: error) { _ in
                guard case .some = error else { return }
                showToast = true
            }
    }
}

extension Error: Equatable {
    static func == (lhs: Error, rhs: Error) -> Bool {
        return lhs.message == rhs.message
    }
}

extension View {
    func errorAlert(_ error: Binding<Error?>) -> some View {
        modifier(ErrorAlert(error: error))
    }
}
