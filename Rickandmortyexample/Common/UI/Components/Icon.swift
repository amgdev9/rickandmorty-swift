import SwiftUI

struct Icon: View {
    let path: String

    static let paths: [Name: String] = [
        .character: "Character",
        .episodes: "Episodes",
        .location: "Location"
    ]

    static let extensions: [Variant: String] = [
        .normal: "",
        .filled: ".Filled",
        .outlined: ".Outlined"
    ]

    init(name: Name, variant: Variant = .normal) {
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

// MARK: - Previews
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

// MARK: - Types
extension Icon {
    enum Name {
        case character
        case location
        case episodes
    }

    enum Variant {
        case normal
        case outlined
        case filled
    }
}
