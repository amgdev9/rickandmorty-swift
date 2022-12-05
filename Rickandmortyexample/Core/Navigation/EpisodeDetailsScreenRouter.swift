import SwiftUI

class SwiftUIEpisodeDetailsScreenRouter: Router & EpisodeDetailsScreenRouter {
    var params: EpisodeDetailsScreenParams

    init(path: Binding<NavigationPath>, params: EpisodeDetailsScreenParams) {
        self.params = params
        super.init(path: path)
    }

    func gotoCharacter(id: String) {
        path.wrappedValue.append(CharacterDetailsScreenParams(id: id))
    }
}
