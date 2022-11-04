import SwiftUI

enum IconName {
    case character
    case location
    case episodes
}

enum IconVariant {
    case normal
    case outlined
    case filled
}

struct Icon: View {
    let path: String

    static let paths: [IconName: String] = [
        .character: "Character",
        .episodes: "Episodes",
        .location: "Location"
    ]

    static let extensions: [IconVariant: String] = [
        .normal: "",
        .filled: ".Filled",
        .outlined: ".Outlined"
    ]

    init(name: IconName, variant: IconVariant = .normal) {
        let name = Icon.paths[name]
        assert(name != nil, "Icon name has not been registered")

        let ext = Icon.extensions[variant]
        assert(ext != nil, "Icon variant has not been registered")

        path = "\(name!)\(ext!)"
    }

    var body: some View {
        Image(path)
    }
}

struct IconPreviews: PreviewProvider {
    static var previews: some View {
        VStack {
            Icon(name: .location, variant: .outlined)
            Icon(name: .location, variant: .filled)
            Icon(name: .character, variant: .outlined)
            Icon(name: .character, variant: .filled)
            Icon(name: .episodes, variant: .outlined)
            Icon(name: .episodes, variant: .filled)
        }
    }
}
