import SwiftUI

class I18N: ObservableObject {
    @Published var language: Locale.Language = Locale.current.language

    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onLocaleChange),
            name: NSLocale.currentLocaleDidChangeNotification,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func t(_ key: String.LocalizationValue) -> String {
        return String(localized: key)
    }

    func tEnum(_ value: LocalizedEnum) -> String {
        return value.localized()
    }

    @objc private func onLocaleChange() {
        language = Locale.current.language
    }
}
