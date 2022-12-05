import SwiftUI

struct CharacterInfo<Character: CharacterInfoData>: View {
    let character: Character
    let onPressLocation: (_ id: String) -> Void

    @EnvironmentObject var i18n: I18N

    var body: some View {
        Text(i18n.t("section/character-info"),
             variant: .body20, weight: .bold, color: .graybaseGray1)
        .padding(.top, 20)
        .padding(.bottom, 9.5)
        .padding(.leading, 16)
        Separator()
        SectionButton(
            title: i18n.t("card/gender"),
            subtitle: character.gender.localized(),
            showBorder: false
        )
        midSeparator()
        SectionButton(
            title: i18n.t("card/origin"),
            subtitle: character.origin?.name ?? i18n.t("misc/unknown"),
            showBorder: false
        )
        midSeparator()
        SectionButton(
            title: i18n.t("card/type"),
            subtitle: character.type ?? i18n.t("misc/unknown"),
            showBorder: false
        )
        midSeparator()
        SectionButton(
            title: i18n.t("card/location"),
            subtitle: character.location?.name ?? i18n.t("misc/unknown"),
            showBorder: false,
            onPress: character.location != nil ? handlePressLocation : .none
        )
        Separator()
    }
}

// MARK: - Styles
extension CharacterInfo {
    func midSeparator() -> some View {
        Separator().offset(x: 16)
    }
}

// MARK: - Logic
extension CharacterInfo {
    func handlePressLocation() {
        guard let location = character.location else { return }
        onPressLocation(location.id)
    }
}

// MARK: - Types
protocol CharacterInfoData {
    var gender: Character.Gender { get }
    var origin: CharacterLocation? { get }
    var type: String? { get }
    var location: CharacterLocation? { get }
}
