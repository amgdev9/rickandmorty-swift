extension Date {
    func formatted(format: String.LocalizationValue) -> String {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate(String(localized: format))
        return formatter.string(from: self)
    }
}
