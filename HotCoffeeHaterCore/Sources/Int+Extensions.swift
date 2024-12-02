//
//  Int+Extensions.swift
//  HotCoffeeHater
//
//  Created by doremin on 11/7/24.
//

import UIKit

extension Int {
  public var koreanCurrency: String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.positivePrefix = ""
    formatter.positiveSuffix.append("원")
    return formatter.string(from: NSNumber(value: self)) ?? ""
  }
}
