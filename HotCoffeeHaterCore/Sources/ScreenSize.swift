//
//  ScreenSize.swift
//  HotCoffeeHater
//
//  Created by doremin on 11/5/24.
//

import UIKit

public var screenSize: CGSize {
  if let windowScene = UIApplication.shared.connectedScenes
    .compactMap({ $0 as? UIWindowScene })
    .first {
    let windowFrame = windowScene.windows.first?.frame
    return CGSize(
      width: windowFrame?.width ?? 0,
      height: windowFrame?.height ?? 0)
  }
  
  return .zero
}
