import SwiftUI
import MapKit

import StoresFeatureEntity

@MainActor
public struct StoreMap: View {
  
  @Binding var stores: [StoreEntity]
  
  public var body: some View {
    Map(
      initialPosition: .camera(
        .init(
          centerCoordinate: .init(
            latitude: 37.5156,
            longitude: 127.111),
          distance: 2000)))
    {
      ForEach(stores, id: \.id) { store in
        Annotation("", coordinate: .init(latitude: store.latitude, longitude: store.longitude), content: {
          StoreMarker(store: store) { store in
            print(store)
          }
        })
      }
    }
  }
}
