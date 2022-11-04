import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello", variant: .h1)
                .font(.system(size: 40))
                .foregroundColor(.basicBlack)
            Text("World", variant: .h2, weight: .semibold)
                .font(.system(size: 13))
                .foregroundColor(.basicBlack)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
