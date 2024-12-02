import SwiftUI

extension View {
  public func hairLine<S: InsettableShape>(_ color: Color, shape: S, fill: Color? = nil) -> some View {
    self.background(
      shape
        .fill(fill ?? .clear)
        .strokeBorder(color, lineWidth: 1, antialiased: true)
    )
  }
  
  public func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
    clipShape(RoundedCorner(radius: radius, corners: corners))
  }
}
