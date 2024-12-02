import UIKit
import MapKit

import StoresFeatureRepository
import StoresFeatureRepositoryImplementation
import StoresFeatureEntity

import RxSwift
import RxCocoa

final public class HomeViewController: BaseViewController<HomeView> {
  // MARK: - Properties
  private let viewModel: HomeViewModel
  private let disposeBag = DisposeBag()
  private let locationManager = LocationManager()
  
  // MARK: - Initialization
  public init(viewModel: HomeViewModel) {
    self.viewModel = viewModel
    super.init()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  public override func viewDidLoad() {
    super.viewDidLoad()
    locationManager.requestAuthorization()
    bind()
  }
  
  // MARK: - Binding
  private func bind() {
    let input = HomeViewModel.Input(
      coordinate: mainView.coordinate.asObservable()
    )
    
    let output = viewModel.transform(input: input)
    
    locationManager.currentLocation
      .take(1)
      .subscribe { [weak self] location in
        guard let self = self else { return }
        mainView.mapView.setRegion(
          MKCoordinateRegion(center: location, latitudinalMeters: 100, longitudinalMeters: 100),
          animated: false)
        locationManager.stopUpdatingLocation()
      }
      .disposed(by: disposeBag)
    
    // Bind stores to tableView
    output.stores
      .drive(onNext: { [weak self] stores in
        guard let self = self else { return }
        self.mainView.stores = stores
        self.mainView.tableView.reloadData()
      })
      .disposed(by: disposeBag)
    
    // Handle errors
    output.error
      .emit(onNext: { [weak self] error in
        self?.showError(error)
      })
      .disposed(by: disposeBag)
    
    output.stores
      .drive(onNext: { [weak self] stores in
        self?.addAnnotations(stores)
      })
      .disposed(by: disposeBag)
    
    output.isLoading
      .drive(onNext: { [weak self] isLoading in
        guard let self = self else { return }
        if isLoading {
          self.mainView.loadingView.startAnimating()
        } else {
          self.mainView.loadingView.stopAnimating()
        }
      })
      .disposed(by: disposeBag)
  }
  
  private func addAnnotations(_ stores: [StoreEntity]) {
    // 기존 annotation 제거
    mainView.mapView.removeAnnotations(mainView.mapView.annotations)
    
    // 새로운 annotation 추가
    let annotations = stores.enumerated().map { index, store in
      StoreAnnotation(
        coordinate: CLLocationCoordinate2D(
          latitude: store.latitude,
          longitude: store.longitude
        ),
        store: store,
        rank: index + 1
      )
    }
    
    mainView.mapView.addAnnotations(annotations)
  }
  
  private func showError(_ error: APIError) {
    let alert = UIAlertController(
      title: "Error",
      message: error.localizedDescription,
      preferredStyle: .alert
    )
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    present(alert, animated: true)
  }
}

#Preview() {
  let repository = DefaultStoresRepository()
  let viewModel = HomeViewModel(storesRepository: repository)
  HomeViewController(viewModel: viewModel)
}
