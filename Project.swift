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
      dependencies: [
        .external(name: "RxSwift"),
        .external(name: "RxCocoa"),
        .external(name: "RxRelay"),
        .external(name: "SnapKit")
      ]
    ),
    .target(
      name: "HotCoffeeHaterTestCore",
      destinations: .iOS,
      product: .framework,
      bundleId: bundleId("HotCoffeeHaterTestCore"),
      dependencies: [
        .external(name: "RxTest"),
        .external(name: "RxBlocking")
      ]
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
      ]
    ),
    
    // Domain Layer
    .target(
      name: "StoresFeatureRepository",
      destinations: .iOS,
      product: .framework,
      bundleId: bundleId("StoresFeatureRepository"),
      sources: ["StoresFeatureRepository/Sources/**"],
      dependencies: [
        .target(name: "StoresFeatureEntity")
      ]
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
      infoPlist: .extendingDefault(
        with: [
          "UILaunchScreen": .dictionary([:])
        ]
      ),
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
        .target(name: "StoresFeatureUIKit"),
        .target(name: "HotCoffeeHaterTestCore")
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
          "UILaunchScreen": [
            "UIColorName": "LaunchBackground",
            "UIImageName": "LaunchIcon",
            "UIImageRespectsSafeAreaInsets": true
          ],
          "UIApplicationSceneManifest": [
            "UIApplicationSupportsMultipleScenes": false,
            "UISceneConfigurations": [
              "UIWindowSceneSessionRoleApplication": [
                [
                  "UISceneConfigurationName": "Default Configuration",
                  "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                ],
              ]
            ]
          ],
          "NSLocationTemporaryUsageDescriptionDictionary": .dictionary([
            "LocationAccuracyRequest": "주변 매장을 찾기 위해 위치 정보를 사용합니다."
          ]),
          "NSLocationWhenInUseUsageDescription": "주변 매장을 찾기 위해 위치 정보가 필요합니다.",
          "CFBundleIconName": "AppIcon",
          "CFBundleName": "얼죽아"
        ]
      ),
      sources: ["HotCoffeeHaterUIKit/Sources/**"],
      resources: ["HotCoffeeHaterUIKit/Resources/**"],
      dependencies: [
        .target(name: "StoresFeatureUIKit"),
      ]
    ),
  ]
)
