import UIKit

import StoresFeatureRepositoryImplementation
import StoresFeatureUIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = scene as? UIWindowScene else { return }
    window = UIWindow(windowScene: windowScene)
    let repository = DefaultStoresRepository()
    let viewModel = HomeViewModel(storesRepository: repository)
    let viewController = HomeViewController(viewModel: viewModel)
    window?.rootViewController = viewController
    window?.makeKeyAndVisible()
  }
}
