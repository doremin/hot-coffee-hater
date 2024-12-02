// swift-tools-version: 6.0
@preconcurrency
import PackageDescription

#if TUIST
import ProjectDescription

let packageSettings = PackageSettings(
  productTypes: [
    "RxSwift": .framework,
    "RxCocoa": .framework,
    "RxRelay": .framework,
    "RxTest": .framework,
    "RxBlocking": .framework,
    "SnapKit": .framework
  ]
)
#endif

let package = Package(
  name: "HotCoffeeHater",
  dependencies: [
    .package(url: "https://github.com/SnapKit/SnapKit", .upToNextMajor(from: "5.7.1")),
    .package(url: "https://github.com/ReactiveX/RxSwift", .upToNextMajor(from: "6.8.0"))
  ],
  targets: [
    .target(
      name: "HotCoffeeHater",
      dependencies: [
        .product(name: "RxSwift", package: "RxSwift"),
        .product(name: "RxCocoa", package: "RxSwift"),
        .product(name: "RxRelay", package: "RxSwift"),
        .product(name: "RxTest", package: "RxSwift"),
        .product(name: "RxBlocking", package: "RxSwift"),
        .product(name: "SnapKit", package: "SnapKit")
      ]
    )
  ]
)
