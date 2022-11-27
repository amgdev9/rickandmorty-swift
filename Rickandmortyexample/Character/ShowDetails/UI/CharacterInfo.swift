import SwiftUI

struct CharacterInfo<Character: CharacterInfoData>: View {
    let character: Character
    let onPressLocation: (_ id: String) -> Void

    var body: some View {
        Text(String(localized: "section/character-info"),
             variant: .body20, weight: .bold, color: .graybaseGray1)
        .padding(.top, 20)
        .padding(.bottom, 9.5)
        .padding(.leading, 16)
        Separator()
        SectionButton(
            title: String(localized: "card/gender"),
            subtitle: character.gender.localized(),
            showBorder: false
        )
        Separator().offset(x: 16)
        SectionButton(
            title: String(localized: "card/origin"),
            subtitle: character.origin?.name ?? String(localized: "misc/unknown"),
            showBorder: false
        )
        Separator().offset(x: 16)
        SectionButton(
            title: String(localized: "card/type"),
            subtitle: character.type ?? String(localized: "misc/unknown"),
            showBorder: false
        )
        Separator().offset(x: 16)
        SectionButton(
            title: String(localized: "card/location"),
            subtitle: character.location?.name ?? String(localized: "misc/unknown"),
            showBorder: false,
            onPress: character.location != nil ? handlePressLocation : .none
        )
        Separator()
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
