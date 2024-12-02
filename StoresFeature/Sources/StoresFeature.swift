import SwiftUI

import StoresFeatureRepository
import StoresFeatureRepositoryImplementation
import StoresFeatureEntity
import HotCoffeeHaterCore

import MapKit
import CoreLocation

public struct StoresView: View {
  
  @State var stores: [StoreEntity] = []
  @State var isLoading = false
  @GestureState private var gestureOffset: CGFloat = 0
  @State private var offset: CGFloat = UIScreen.main.bounds.height * 0.7
  
  private let storeRepository: StoresRepository
  
  public init(storeRepository: StoresRepository) {
    self.storeRepository = storeRepository
  }
  
  public var body: some View {
    GeometryReader { proxy in
      let screenHeight = proxy.size.height
      
      let minHeight = screenHeight * 0.3
      let maxHeight: CGFloat = screenHeight - 94
      
      ZStack(alignment: .top) {
        // top view
        ZStack {
          StoreMap(stores: $stores)
          Button("Load") {
            Task {
              try await loadStores()
            }
          }
        }
        .frame(height: max(minHeight, min(maxHeight, offset + gestureOffset)))
        .ignoresSafeArea()
        
        VStack(spacing: 0) {
          Capsule()
            .fill(Color.gray300)
            .frame(width: 36, height: 4)
            .padding(.vertical, 8)
          // bottom view
          ScrollView {
            LazyVStack {
              ForEach(0..<20) { i in
                Text("Item \(i)")
                  .padding()
              }
            }
          }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
          RoundedCorner(radius: 16, corners: [.topRight, .topLeft])
            .fill(.black)
        )
        .offset(y: max(minHeight, min(maxHeight, offset + gestureOffset)))
        .ignoresSafeArea()
        .gesture(
          DragGesture()
            .updating($gestureOffset) { value, state, _ in
              state = value.translation.height
            }
            .onEnded { value in
              offset = max(minHeight, min(maxHeight, offset + value.translation.height))
            }
        )
      }
    }
    
  }
  
  private func loadStores() async throws {
    isLoading = true
    stores = try await storeRepository.getStores(latitude: 37.5156, longitude: 127.111)
    isLoading = false
  }
}

#Preview("Store View") {
  let storeRepository = DefaultStoresRepository()
  StoresView(storeRepository: storeRepository)
}
