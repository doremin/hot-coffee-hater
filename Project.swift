import ProjectDescription

func bundleId(_ name: String) -> String {
  return "com.doremin.\(name)"
}

let project = Project(
  name: "HotCoffeeHater",
  targets: [
    // Core
    .target(
      name: "HotCoffeeHaterCore",
      destinations: .iOS,
      product: .framework,
      bundleId: bundleId("HotCoffeeHaterCore"),
      sources: ["HotCoffeeHaterCore/Sources/**"],
      resources: ["HotCoffeeHaterCore/Resources/**"]
    ),
    
    // Data Layer
    .target(
      name: "StoresFeatureEntity",
      destinations: .iOS,
      product: .framework,
      bundleId: bundleId("StoresFeatureEntity"),
      sources: ["StoresFeatureEntity/Sources/**"]
    ),

    .target(
      name: "StoresFeatureRepositoryImplementation",
      destinations: .iOS,
      product: .framework,
      bundleId: bundleId("StoresFeatureRepositoryImplementation"),
      sources: ["StoresFeatureRepositoryImplementation/Sources/**"],
      dependencies: [
        .target(name: "StoresFeatureRepository"),
        .target(name: "StoresFeatureEntity")
      ]
    ),
    
    // Domain Layer
    .target(
      name: "StoresFeatureRepository",
      destinations: .iOS,
      product: .framework,
      bundleId: bundleId("StoresFeatureRepository"),
      sources: ["StoresFeatureRepository/Sources/**"]
    ),
    
    // Features
    // --Stores Feature (SwiftUI)
    .target(
      name: "StoresFeature",
      destinations: .iOS,
      product: .framework,
      bundleId: bundleId("StoresFeature"),
      sources: ["StoresFeature/Sources/**"],
      dependencies: [
        .target(name: "StoresFeatureRepository"),
        .target(name: "StoresFeatureRepositoryImplementation"),
        .target(name: "HotCoffeeHaterCore")
      ]
    ),
    .target(
      name: "StoresFeatureTests",
      destinations: .iOS,
      product: .unitTests,
      bundleId: bundleId("StoresFeatureTests"),
      sources: ["StoresFeature/Tests/**"],
      dependencies: [
        .target(name: "StoresFeature")
      ]
    ),
    .target(
      name: "StoresFeatureExample",
      destinations: .iOS,
      product: .app,
      bundleId: bundleId("StoresFeatureExample"),
      sources: ["StoresFeature/Example/**"],
      dependencies: [
        .target(name: "StoresFeature")
      ]
    ),
    
    // --Stores Feature (UIKit)
    .target(
      name: "StoresFeatureUIKit",
      destinations: .iOS,
      product: .framework,
      bundleId: bundleId("StoresFeatureUIKit"),
      sources: ["StoresFeatureUIKit/Sources/**"],
      dependencies: [
        .target(name: "StoresFeatureRepository"),
        .target(name: "StoresFeatureRepositoryImplementation"),
        .target(name: "HotCoffeeHaterCore")
      ]
    ),
    .target(
      name: "StoresFeatureUIKitTests",
      destinations: .iOS,
      product: .unitTests,
      bundleId: bundleId("StoresFeatureUIKitTests"),
      sources: ["StoresFeatureUIKit/Tests/**"],
      dependencies: [
        .target(name: "StoresFeatureUIKit")
      ]
    ),
    
    // App
    // --SwiftUI Version
    .target(
      name: "HotCoffeeHater",
      destinations: .iOS,
      product: .app,
      bundleId: bundleId("HotCoffeeHater"),
      infoPlist: .extendingDefault(
        with: [
          "UILaunchScreen": .dictionary([:])
        ]
      ),
      sources: ["HotCoffeeHater/Sources/**"],
      resources: ["HotCoffeeHater/Resources/**"],
      dependencies: [
        .target(name: "StoresFeature")
      ]
    ),
    .target(
      name: "HotCoffeeHaterTests",
      destinations: .iOS,
      product: .unitTests,
      bundleId: bundleId("HotCoffeeHaterTests"),
      infoPlist: .default,
      sources: ["HotCoffeeHater/Tests/**"],
      dependencies: [
        .target(name: "HotCoffeeHater")
      ]
    ),
    
    // --UIKit Version
    .target(
      name: "HotCoffeeHaterUIKit",
      destinations: .iOS,
      product: .app,
      bundleId: bundleId("HotCoffeeHaterUIKit"),
      infoPlist: .extendingDefault(
        with: [
          "UILaunchScreen": .dictionary([:])
        ]
      ),
      sources: ["HotCoffeeHaterUIKit/Sources/**"],
      resources: ["HotCoffeeHaterUIKit/Resources/**"],
      dependencies: [
        .target(name: "StoresFeatureUIKit")
      ]
    ),
  ]
)
