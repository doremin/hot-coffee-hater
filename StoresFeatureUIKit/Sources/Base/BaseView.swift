import UIKit

import HotCoffeeHaterCore

// Rx
import RxCocoa
import RxSwift

// Layout
import SnapKit

open class BaseView: UIView {
  
  open var viewGraph: [UIView] {
    []
  }
  
  public init() {
    super.init(frame: .zero)
    
    viewGraph.forEach { addSubview($0) }
    setupConstraints()
  }
  
  required public init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  func setupConstraints() {
    // override point
  }
}
