import SwiftUI

class SwiftUILocationDetailsScreenRouter: Router & LocationDetailsScreenRouter {
    var params: LocationDetailsScreenParams

    init(path: Binding<NavigationPath>, params: LocationDetailsScreenParams) {
        self.params = params
        super.init(path: path)
    }

    func gotoCharacter(id: String) {
        path.wrappedValue.append(CharacterDetailsScreenParams(id: id))
    }
}
