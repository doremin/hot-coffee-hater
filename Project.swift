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
    .target(
      name: "HotCoffeeHaterCoreTests",
      destinations: .iOS,
      product: .unitTests,
      bundleId: bundleId("HotCoffeeHaterCoreTests"),
      sources: ["HotCoffeeHaterCore/Tests/**"],
      dependencies: [
        .target(name: "HotCoffeeHaterCore")
      ]
    ),
    
    // Data Layer
    .target(
      name: "HotCoffeeHaterModels",
      destinations: .iOS,
      product: .framework,
      bundleId: bundleId("HotCoffeeHaterModels"),
      sources: ["HotCoffeeHaterModels/Sources/**"]
    ),
    .target(
      name: "HotCoffeeHaterModelsTests",
      destinations: .iOS,
      product: .unitTests,
      bundleId: bundleId("HotCoffeeHaterModelsTests"),
      sources: ["HotCoffeeHaterModels/Tests/**"],
      dependencies: [
        .target(name: "HotCoffeeHaterModels")
      ]
    ),
    
    // App
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
        .target(name: "HotCoffeeHaterCore")
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
  ]
)
