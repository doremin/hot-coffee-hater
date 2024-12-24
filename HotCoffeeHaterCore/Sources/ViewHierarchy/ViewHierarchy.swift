//
//  ViewHierarchy.swift
//  HotCoffeeHater
//
//  Created by doremin on 10/31/24.
//

import UIKit

public struct ViewHierarchy {
  public let views: [UIView]
  
  public init(views: [UIView]) {
    self.views = views
  }
}

@resultBuilder
public struct ViewHierarchyBuilder {
  
  public static func buildExpression(_ expression: UIView) -> ViewHierarchy {
    return ViewHierarchy(views: [expression])
  }
  
  public static func buildExpression(_ expression: [UIView]) -> ViewHierarchy {
    return ViewHierarchy(views: expression)
  }
  
  public static func buildBlock(_ components: ViewHierarchy...) -> ViewHierarchy {
    return ViewHierarchy(views: components.flatMap { $0.views })
  }
  
}

extension UIView {
  @discardableResult
  public func callAsFunction(@ViewHierarchyBuilder _ builder: () -> ViewHierarchy) -> UIView {
    builder().views.forEach { addSubview($0) }
    return self
  }
}
