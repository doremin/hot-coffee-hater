//
//  StoreLoadingView.swift
//  HotCoffeeHater
//
//  Created by doremin on 12/2/24.
//

import UIKit
import HotCoffeeHaterCore

@MainActor
final class StoreLoadingView: BaseView {
  
  private let dots: [UIView] = createDots()
  
  @ViewHierarchyBuilder
  override var viewHierarchy: ViewHierarchy {
    dots
  }
  
  private static func createDots() -> [UIView] {
    (0 ..< 3).map { _ in
      let view = UIView()
      view.backgroundColor = .purple700
      view.layer.cornerRadius = 1
      return view
    }
  }
  
  override init() {
    super.init()
    setupStoreLoadingView()
  }
  
  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupStoreLoadingView() {
    backgroundColor = .white
    transform = CGAffineTransform(scaleX: 0.9375, y: 0.875)
    layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 12).cgPath
    layer.shadowColor = UIColor.black.withAlphaComponent(0.12).cgColor
    layer.shadowOpacity = 1
    layer.shadowRadius = 12
    layer.shadowOffset = CGSize(width: 0, height: 2)
    layer.cornerRadius = 12
    isHidden = true
  }
  
  override func setupConstraints() {
    dots.enumerated().forEach { index, dot in
      dot.snp.makeConstraints { make in
        make.centerY.equalToSuperview()
        make.size.equalTo(2)
        make.centerX.equalToSuperview().offset((index - 1) * 16)
      }
    }
  }
  
  func startAnimating() {
    UIView.animate(withDuration: 0.2, delay: .zero, options: [.curveEaseInOut]) {
      self.transform = .identity
      self.isHidden = false
      self.layer.opacity = 1
    }
    
    dots.enumerated().forEach { index, dot in
      UIView.animate(
        withDuration: 0.4,
        delay: Double(index) * 0.2,  // 각 dot마다 0.2초씩 딜레이
        options: [.curveEaseInOut, .autoreverse, .repeat],
        animations: {
          dot.transform = CGAffineTransform(scaleX: 4, y: 4)
          dot.layer.cornerRadius = 0.5
        }
      )
    }
  }
  
  func stopAnimating() {
    UIView.animate(withDuration: 0.2, delay: .zero, options: [.curveEaseInOut]) {
      self.transform = CGAffineTransform(scaleX: 0.9375, y: 0.875)
      self.layer.opacity = 0
    } completion: { _ in
      self.isHidden = true
      self.dots.forEach { dot in
        dot.layer.removeAllAnimations()
        dot.transform = .identity
        dot.layer.cornerRadius = 1
      }
    }
  }
}

#Preview("Store Loading View") {
  StoreLoadingView()
}
