//
//  ViewGraph.swift
//  HotCoffeeHater
//
//  Created by doremin on 10/31/24.
//

import UIKit

@resultBuilder
public struct ViewGraphBuilder {
  
  public static func buildExpression(_ expression: UIView) -> UIView {
    return expression
  }
  
  public static func buildBlock(_ components: UIView...) -> [UIView] {
    return components
  }
}

extension UIView {
  @discardableResult
  public func callAsFunction(@ViewGraphBuilder _ builder: () -> [UIView]) -> UIView {
    builder().forEach { addSubview($0) }
    return self
  }
}
