import SwiftUI

import StoresFeatureRepository
import StoresFeatureRepositoryImplementation
import StoresFeatureEntity
import StoresFeature
import HotCoffeeHaterCore

@main
struct StoresFeatureExampleApp: App {
  
  var body: some Scene {
    WindowGroup {
      StoresView(storeRepository: DefaultStoresRepository())
    }
  }
}
