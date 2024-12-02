import SwiftUI

public struct PercentageHeightModifier: ViewModifier {
  public let percentage: CGFloat
  
  public func body(content: Content) -> some View {
    GeometryReader { geometry in
      content
        .frame(height: geometry.size.height * percentage)
    }
  }
}

extension View {
  public func percentageHeight(_ percentage: CGFloat) -> some View {
    modifier(PercentageHeightModifier(percentage: percentage))
  }
}
