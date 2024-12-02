//
//  StoreAnnotation.swift
//  HotCoffeeHater
//
//  Created by doremin on 11/6/24.
//

import UIKit
import MapKit

import StoresFeatureEntity

final public class StoreAnnotation: NSObject, MKAnnotation {
  public let coordinate: CLLocationCoordinate2D
  public let store: StoreEntity
  public let rank: Int
  
  public init(coordinate: CLLocationCoordinate2D, store: StoreEntity, rank: Int) {
    self.coordinate = coordinate
    self.store = store
    self.rank = rank
  }
}

final public class StoreAnnotationView: MKAnnotationView {
  
  private let containerView: UIView = {
    let view = UIView()
    view.backgroundColor = .sky200
    view.layer.cornerRadius = 15
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
    view.layer.shadowOffset = CGSize(width: 0, height: 2)
    view.layer.shadowRadius = 2
    view.layer.shadowOpacity = 1
    return view
  }()
  
  private let priceLabel: UILabel = {
    let label = UILabel()
    label.textColor = .sky700
    label.font = .systemFont(ofSize: 12, weight: .bold)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let rankLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.backgroundColor = .sky500
    label.textColor = .sky200
    label.font = .systemFont(ofSize: 10, weight: .bold)
    label.layer.cornerRadius = 10
    label.translatesAutoresizingMaskIntoConstraints = false
    label.clipsToBounds = true
    return label
  }()
  
  private let maximumRank = 3
  
  public override init(annotation: (any MKAnnotation)?, reuseIdentifier: String?) {
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    setupViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupViews() {
    addSubview(containerView)
    containerView.addSubview(rankLabel)
    containerView.addSubview(priceLabel)
    
    containerView.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.right.equalTo(priceLabel.snp.right).offset(12)
      make.height.equalTo(30)
    }
    
    rankLabel.snp.makeConstraints { make in
      make.size.equalTo(20)
      make.left.equalToSuperview().offset(6)
      make.centerY.equalToSuperview()
    }
    
    priceLabel.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.left.equalTo(rankLabel.snp.right).offset(3)
    }
  }
  
  public func configure(with annotation: StoreAnnotation, rank: Int) {
    layer.opacity = 0
    transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
    priceLabel.text = annotation.store.americano.price.formatted()
    
    let isRankVisible = rank < maximumRank + 1
    rankLabel.snp.updateConstraints { make in
      make.size.equalTo(isRankVisible ? 20 : 3)
    }
    rankLabel.isHidden = !isRankVisible
    rankLabel.text = isRankVisible ? "\(rank)" : ""
    startAnimating()
  }
  
  private func startAnimating() {
    UIView.animate(withDuration: 0.2) {
      self.layer.opacity = 1
      self.transform = .identity
    }
  }
}

#Preview {
  StoreAnnotationView()
}
