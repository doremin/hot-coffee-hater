//
//  StoreTableViewCell.swift
//  HotCoffeeHater
//
//  Created by doremin on 11/6/24.
//

import UIKit

import StoresFeatureEntity
import HotCoffeeHaterCore

public class StoreCell: UITableViewCell {
  
  private let storeNameLabel: UILabel = {
    let label = UILabel()
    label.textColor = .gray800
    label.font = .systemFont(ofSize: 16, weight: .bold)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let rankLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 12, weight: .bold)
    label.layer.cornerRadius = 12
    label.clipsToBounds = true
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    return label
  }()
  
  private let americanoLabel: UILabel = {
    let label = UILabel()
    label.textColor = .gray500
    label.font = .systemFont(ofSize: 16, weight: .regular)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let priceLabel: UILabel = {
    let label = UILabel()
    label.textColor = .gray800
    label.font = .systemFont(ofSize: 16, weight: .bold)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let maximumRank: Int = 3
  
  private var propertyAnimator: UIViewPropertyAnimator?
  
  public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    animateScale(isDown: true)
  }
  
  public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    animateScale(isDown: false)
  }
  
  public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesCancelled(touches, with: event)
    animateScale(isDown: false)
  }
  
  public func animateScale(isDown: Bool, animated: Bool = true, delay: TimeInterval = 0.0) {
    if animated {
      UIView.animate(
        withDuration: 0.1,
        delay: delay,
        options: [.allowUserInteraction, .beginFromCurrentState],
        animations: {
          self.transform = isDown ?
          CGAffineTransform(scaleX: 0.95, y: 0.95) : .identity
          self.contentView.alpha = isDown ? 0.7 : 1.0
        }
      )
    } else {
      self.transform = isDown ? CGAffineTransform(scaleX: 0.9, y: 0.9) : .identity
      self.contentView.alpha = isDown ? 0.5 : 1.0
    }
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    backgroundColor = .white
    selectionStyle = .none
    propertyAnimator = UIViewPropertyAnimator(duration: 0.1, curve: .easeInOut)
    propertyAnimator?.addAnimations { [weak self] in
      self?.backgroundColor = .black.withAlphaComponent(0.3)
    }
    propertyAnimator?.addCompletion { [weak self] _ in
      self?.backgroundColor = .white
    }
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupViews() {
    contentView.addSubview(rankLabel)
    contentView.addSubview(storeNameLabel)
    contentView.addSubview(americanoLabel)
    contentView.addSubview(priceLabel)
    
    rankLabel.snp.makeConstraints { make in
      make.left.equalToSuperview().offset(20)
      make.size.equalTo(24)
      make.centerY.equalToSuperview()
    }
    
    storeNameLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(14)
      make.left.equalTo(rankLabel.snp.right).offset(20)
    }
    
    americanoLabel.snp.makeConstraints { make in
      make.left.equalTo(storeNameLabel)
      make.top.equalTo(storeNameLabel.snp.bottom).offset(5)
    }
    
    priceLabel.snp.makeConstraints { make in
      make.centerY.equalTo(americanoLabel)
      make.left.equalTo(americanoLabel.snp.right).offset(6)
    }
  }
  
  public func configure(with store: StoreEntity, rank: Int) {
    storeNameLabel.text = store.name
    rankLabel.text = "\(rank)"
    rankLabel.backgroundColor = rank > maximumRank ? .clear : .gray700
    rankLabel.textColor = rank > maximumRank ? .gray800 : .white
    americanoLabel.text = store.americano.name
    priceLabel.text = store.americano.price.koreanCurrency
  }
}
