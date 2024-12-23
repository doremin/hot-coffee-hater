//
//  ViewGraph.swift
//  HotCoffeeHater
//
//  Created by doremin on 10/31/24.
//

import UIKit

public struct ViewGraph {
  public let views: [UIView]
  
  public init(views: [UIView]) {
    self.views = views
  }
}

@resultBuilder
public struct ViewGraphBuilder {
  
  public static func buildExpression(_ expression: UIView) -> ViewGraph {
    return ViewGraph(views: [expression])
  }
  
  public static func buildExpression(_ expression: [UIView]) -> ViewGraph {
    return ViewGraph(views: expression)
  }
  
  public static func buildBlock(_ components: ViewGraph...) -> ViewGraph {
    return ViewGraph(views: components.flatMap { $0.views })
  }
  
}

extension UIView {
  @discardableResult
  public func callAsFunction(@ViewGraphBuilder _ builder: () -> [UIView]) -> UIView {
    builder().forEach { addSubview($0) }
    return self
  }
  
  @discardableResult
  public func callAsFunction(@ViewGraphBuilder _ builder: () -> ViewGraph) -> UIView {
    builder().views.forEach { addSubview($0) }
    return self
  }
}
