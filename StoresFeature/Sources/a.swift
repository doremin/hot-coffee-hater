import SwiftUI

struct DraggableSplitView<Top: View, Bottom: View>: View {
  let topView: Top
  let bottomView: Bottom
  
  @State private var offset: CGFloat = 300
  @GestureState private var dragOffset: CGFloat = 0
  
  let minHeight: CGFloat
  let maxHeight: CGFloat
  
  init(minHeight: CGFloat = 100,
       maxHeight: CGFloat = 600,
       @ViewBuilder top: () -> Top,
       @ViewBuilder bottom: () -> Bottom) {
    self.minHeight = minHeight
    self.maxHeight = maxHeight
    self.topView = top()
    self.bottomView = bottom()
  }
  
  var body: some View {
    GeometryReader { geometry in
      ZStack(alignment: .top) {
        topView
          .frame(height: max(minHeight, min(maxHeight, offset + dragOffset)))
        
        
        VStack(spacing: 0) {
          Rectangle()
            .fill(Color.gray.opacity(0.3))
            .frame(width: 40, height: 4)
            .cornerRadius(2)
            .padding(.top, 8)
          
          bottomView
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .cornerRadius(12)
        .offset(y: max(minHeight, min(maxHeight, offset + dragOffset)))
        .gesture(
          DragGesture()
            .updating($dragOffset) { value, state, _ in
              state = value.translation.height
            }
            .onEnded { value in
              offset = max(minHeight, min(maxHeight, offset + value.translation.height))
            }
        )
      }
    }
  }
}

// 사용 예시
public struct ContentView: View {
  
  public init() {}
  
  public var body: some View {
    DraggableSplitView(minHeight: 200, maxHeight: 600) {
      VStack {
        Rectangle()
          .fill(Gradient(colors: [.black, .red, .yellow]))
      }
      
    } bottom: {
      ScrollView {
        LazyVStack {
          ForEach(0..<20) { i in
            Text("Item \(i)")
              .padding()
          }
        }
        .padding(.top)
      }
    }
  }
}

#Preview {
  ContentView()
}
