import SwiftUI

enum Variant {
    case h1
    case h2
    case h3
    case body20
    case body17
    case body15
    case largeTitle
    case caption13
    case caption11
    case tagline15
    case tagline13
    case tagline11
}

class TextStyle {
    let fontSize: CGFloat
    let fontWeight: Font.Weight
    let color: Color
    let lineHeight: CGFloat
    let letterSpacing: CGFloat

    init(fontSize: CGFloat, fontWeight: Font.Weight, color: Color, lineHeight: CGFloat, letterSpacing: CGFloat) {
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.color = color
        self.lineHeight = lineHeight
        self.letterSpacing = letterSpacing
    }
}

enum Weight {
    case bold
    case semibold
}

struct Text: View {
    let content: String
    let textStyle: TextStyle
    let fontWeight: Font.Weight
    let color: Color

    static let textStyles: [Variant: TextStyle] = [
        .h1: TextStyle(fontSize: 40, fontWeight: .bold, color: .basicBlack, lineHeight: 48, letterSpacing: 0.41),
        .h2: TextStyle(fontSize: 28, fontWeight: .bold, color: .basicBlack, lineHeight: 34, letterSpacing: 0.34),
        .h3: TextStyle(fontSize: 22, fontWeight: .regular, color: .basicBlack, lineHeight: 28, letterSpacing: 0.35),
        .body20: TextStyle(fontSize: 20, fontWeight: .regular, color: .basicBlack, lineHeight: 25, letterSpacing: 0.38),
        .body17: TextStyle(fontSize: 17, fontWeight: .regular, color: .basicBlack, lineHeight: 22,
                           letterSpacing: -0.41),
        .body15: TextStyle(fontSize: 15, fontWeight: .regular, color: .basicBlack, lineHeight: 20,
                           letterSpacing: -0.24),
        .caption13: TextStyle(fontSize: 13, fontWeight: .regular, color: .basicBlack, lineHeight: 18,
                              letterSpacing: -0.08),
        .caption11: TextStyle(fontSize: 11, fontWeight: .regular, color: .basicBlack, lineHeight: 13,
                              letterSpacing: 0.07),
        .tagline15: TextStyle(fontSize: 15, fontWeight: .semibold, color: .basicBlue, lineHeight: 20,
                              letterSpacing: -0.24),
        .tagline13: TextStyle(fontSize: 13, fontWeight: .semibold, color: .primaryIndigo,
                              lineHeight: 18, letterSpacing: -0.08),
        .tagline11: TextStyle(fontSize: 11, fontWeight: .semibold, color: .primaryIndigo,
                              lineHeight: 13, letterSpacing: 0.07),
        .largeTitle: TextStyle(fontSize: 34, fontWeight: .bold, color: .basicBlack, lineHeight: 41, letterSpacing: 0.41)
    ]

    static let textWeight: [Weight: Font.Weight] = [
        .bold: .bold,
        .semibold: .semibold
    ]

    init(_ content: String, variant: Variant, weight: Weight? = .none, color: Color? = .none) {
        self.content = content

        let textStyle = Text.textStyles[variant]
        assert(textStyle != nil, "Text variant has not been configured")
        self.textStyle = textStyle!

        let fontWeight = weight != .none ? Text.textWeight[weight.unsafelyUnwrapped] : self.textStyle.fontWeight
        assert(fontWeight != nil, "Font wright has not been configured")
        self.fontWeight = fontWeight!

        self.color = color ?? self.textStyle.color
    }

    var body: some View {
        SwiftUI.Text(content)
            .fontWithLineHeight(font: .systemFont(ofSize: textStyle.fontSize), lineHeight: textStyle.lineHeight)
            .fontWeight(fontWeight)
            .kerning(textStyle.letterSpacing)
            .foregroundColor(color)
    }
}

struct Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Group {
                    Text("Medium length headline", variant: .h1)
                    Text("Medium length headline", variant: .h2)
                    Text("Medium length headline", variant: .h3, weight: .bold)
                    Text("Medium length headline", variant: .h3, color: .primaryIndigo)
                    Text("Medium length headline", variant: .body20, weight: .bold)
                    Text("Medium length headline", variant: .body20, color: .primaryIndigo)
                    Text("Medium length headline", variant: .body17, weight: .bold)
                    Text("Medium length headline", variant: .body17)
                }
                Text("Medium length headline", variant: .body15, weight: .semibold)
                Text("Medium length headline", variant: .largeTitle)
                Text("Medium length headline", variant: .caption13)
                Text("Medium length headline", variant: .caption11)
                Text("Medium length headline", variant: .tagline15)
                Text("Medium length headline", variant: .tagline13)
                Text("Medium length headline", variant: .tagline11)
            }.padding()
        }
    }
}
