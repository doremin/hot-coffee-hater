import SwiftUI
import HotCoffeeHaterCore

public struct ContentView: View {
  public init() {}
  
  private let core = HotCoffeeHaterCoreExample()
  
  public var body: some View {
    Text(core.text)
      .padding()
  }
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
