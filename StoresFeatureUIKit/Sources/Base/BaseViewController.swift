import UIKit

import HotCoffeeHaterCore

import RxSwift
import RxCocoa
import SnapKit

public class BaseViewController<BaseView: UIView>: UIViewController {
  
  var mainView: BaseView {
    view as! BaseView
  }
  
  public init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    defineSubviews()
    setupConstraints()
  }
  
  public override func loadView() {
    view = BaseView()
  }
  
  func defineSubviews() {
    // override point
  }
  
  func setupConstraints() {
    // override point
  }
}
