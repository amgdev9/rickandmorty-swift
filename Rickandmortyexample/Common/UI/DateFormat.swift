extension Date {
    func formatted(format: String.LocalizationValue) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = String(localized: format)
        formatter.locale = Locale(identifier: "en_US")  // TODO Change when supporting multiple languages
        return formatter.string(from: self)
    }
}
