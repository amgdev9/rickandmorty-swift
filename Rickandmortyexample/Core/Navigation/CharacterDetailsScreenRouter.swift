import SwiftUI

class SwiftUICharacterDetailsScreenRouter: Router & CharacterDetailsScreenRouter {
    var params: CharacterDetailsScreenParams

    init(path: Binding<NavigationPath>, params: CharacterDetailsScreenParams) {
        self.params = params
        super.init(path: path)
    }

    func gotoLocation(id: String) {
        path.wrappedValue.append(LocationDetailsScreenParams(id: id))
    }

    func gotoEpisode(id: String) {
        path.wrappedValue.append(EpisodeDetailsScreenParams(id: id))
    }
}
