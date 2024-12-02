import SwiftUI

import StoresFeatureEntity
import HotCoffeeHaterCore

public struct StoreMarker: View {
  
  @State var isSelected: Bool
  
  private let store: StoreEntity
  private let onSelected: (StoreEntity) -> Void
  
  public init(
    store: StoreEntity,
    isSelected: Bool = false,
    onSelected: @escaping (StoreEntity) -> Void)
  {
    self.store = store
    self.onSelected = onSelected
    self._isSelected = .init(initialValue: isSelected)
  }
  
  public var body: some View {
    HStack(spacing: 4) {
      Circle()
        .frame(width: 20, height: 20)
        .foregroundStyle(Color.sky500)
        .overlay {
          Text("1")
            .font(.system(size: 12))
            .foregroundStyle(Color.sky200)
        }
      Text("\(store.americano.price)원")
        .font(.system(size: 12, weight: .bold))
        .foregroundStyle(Color.sky700)
        .lineLimit(1)
        .fixedSize(horizontal: true, vertical: false)
    }
    .padding(.horizontal, 12)
    .padding(.vertical, 8)
    .hairLine(.sky700.opacity(0.15), shape: Capsule(), fill: .sky200)
    .clipShape(.capsule)
    .onTapGesture {
      isSelected.toggle()
      
      if isSelected {
        onSelected(store)
      }
    }
    .shadow(
      color: .black.opacity(0.2), radius: 2,
      x: 0, y: 2)
  }
}

#Preview("Light Mode") {
  StoreMarker(store: StoreEntityFixture.create()) { store in
    print(store)
  }
}
