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

    func tDate(_ date: Date, format: String.LocalizationValue) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = String(localized: format)
        formatter.locale = Locale(identifier: language.languageCode?.identifier ?? "en_US")
        return formatter.string(from: date)
    }

    @objc private func onLocaleChange() {
        language = Locale.current.language
    }
}
