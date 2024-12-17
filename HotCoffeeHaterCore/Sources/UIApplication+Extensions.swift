//
//  UIApplication+Extensions.swift
//  HotCoffeeHater
//
//  Created by doremin on 12/10/24.
//

import UIKit

public extension UIApplication {
  func clearLaunchScreenCache() {
    #if DEBUG
    do {
      let launchScreenPath = "\(NSHomeDirectory())/Library/SplashBoard"
      try FileManager.default.removeItem(atPath: launchScreenPath)
    } catch {
      print("Failed to delete launch screen cache - \(error)")
    }
    #endif
  }
}
