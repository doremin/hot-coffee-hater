import MapKit
import UIKit
import SnapKit

import HotCoffeeHaterCore
import StoresFeatureEntity

import RxSwift
import RxCocoa

// MARK: - HomeView
final public class HomeView: BaseView {
  
  @ViewGraphBuilder
  public override var viewGraph: ViewGraph {
    mapView
    bottomView {
      dragHandle
      bottomViewTitleLabel
      tableView
    }
    loadingView
    myLocationButton {
      myLocationImageView
    }
  }

  // MARK: - UI Components
  let mapView: MKMapView = {
    let view = MKMapView()
    view.isZoomEnabled = true
    view.isScrollEnabled = true
    view.layoutMargins = UIEdgeInsets(
      top: 0,
      left: 0,
      bottom: screenSize.height * BottomSheetState.partial.heightRatio - 32,
      right: 0
    )
    view.showsUserLocation = true
    return view
  }()
  
  let bottomView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.layer.cornerRadius = 16
    view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOpacity = 0.1
    view.layer.shadowRadius = 8
    view.layer.shadowOffset = CGSize(width: 0, height: -4)
    
    let targetTranslation = -screenSize.height *
    (BottomSheetState.partial.heightRatio - BottomSheetState.collapsed.heightRatio)
    view.transform = CGAffineTransform(translationX: 0, y: targetTranslation)
    return view
  }()
  
  let bottomViewTitleLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.font = .systemFont(ofSize: 18, weight: .bold)
    label.text = "이 주변 저렴한 아이스 아메리카노"
    return label
  }()
  
  let dragHandle: UIView = {
    let view = UIView()
    view.backgroundColor = .gray300
    view.layer.cornerRadius = 2
    return view
  }()
  
  let tableView: UITableView = {
    let view = UITableView()
    view.backgroundColor = .white
    view.separatorStyle = .singleLine
    view.separatorColor = .gray500
    view.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    view.register(StoreCell.self, forCellReuseIdentifier: "StoreCell")
    return view
  }()
  
  let loadingView = StoreLoadingView()
  
  let myLocationButton: UIButton = {
    let button = UIButton()
    button.layer.cornerRadius = 12
    button.backgroundColor = .white
    return button
  }()
  
  let myLocationImageView: UIImageView = {
    let view = UIImageView()
    view.image = UIImage(systemName: "scope")
    view.tintColor = .black
    view.contentMode = .scaleAspectFit
    return view
  }()
  
  let panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer()
  
  // MARK: - Properties
  private(set) var currentDetent: BottomSheetState = .partial {
    didSet {
      updateBottomSheetState(currentDetent)
    }
  }
  private var panGestureStartLocation: CGFloat = 0
  private var bottomViewStartTransform: CGAffineTransform = .identity
  private var isSetRegionFromTableView = false
  
  var stores: [StoreEntity] = []
  
  // MARK: - RX
  let bottomSheetStateSubject = PublishSubject<BottomSheetState>()
  let storeSelectedSubject = PublishSubject<StoreEntity>()
  let coordinate = PublishRelay<CLLocationCoordinate2D>()
  
  // MARK: - Initialization
  public override init() {
    super.init()
    setupViews()
    setupGestures()
    printViewHierarchy()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Setup
  private func setupViews() {
    tableView.delegate = self
    tableView.dataSource = self
    mapView.delegate = self
    mapView.register(
      StoreAnnotationView.self,
      forAnnotationViewWithReuseIdentifier: "StoreAnnotationView"
    )
    myLocationButton.addTarget(self, action: #selector(myLocationButtonDidTapped), for: .touchUpInside)
    setupConstraints()
  }
  
  override func setupConstraints() {
    mapView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    loadingView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16)
      make.width.equalTo(75)
      make.height.equalTo(35)
    }
    
    bottomView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(screenSize.height * BottomSheetState.expanded.heightRatio)
      make.bottom.equalToSuperview().offset(
        screenSize.height *
        (BottomSheetState.expanded.heightRatio - BottomSheetState.collapsed.heightRatio)
      )
    }
    
    bottomViewTitleLabel.snp.makeConstraints { make in
      make.left.equalTo(20)
      make.top.equalTo(dragHandle.snp.bottom).offset(14)
    }
    
    dragHandle.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(12)
      make.centerX.equalToSuperview()
      make.width.equalTo(36)
      make.height.equalTo(4)
    }
    
    tableView.snp.makeConstraints { make in
      make.top.equalTo(bottomViewTitleLabel.snp.bottom).offset(14)
      make.horizontalEdges.bottom.equalToSuperview()
    }
    
    myLocationButton.snp.makeConstraints { make in
      make.size.equalTo(40)
      make.right.equalToSuperview().offset(-16)
      make.centerY.equalTo(loadingView)
    }
    
    myLocationImageView.snp.makeConstraints { make in
      make.size.equalTo(24)
      make.center.equalToSuperview()
    }
  }
  
  private func setupGestures() {
    panGesture.addTarget(self, action: #selector(handlePanGesture))
    panGesture.delegate = self
    bottomView.addGestureRecognizer(panGesture)
  }
  
  // MARK: - Gesture Handling
  @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
    tableView.isUserInteractionEnabled = false
    defer { tableView.isUserInteractionEnabled = true }
    
    let translation = gesture.translation(in: self)
    
    switch gesture.state {
    case .began:
      panGestureStartLocation = translation.y
      bottomViewStartTransform = bottomView.transform
      
    case .changed:
      let deltaY = translation.y - panGestureStartLocation
      let newTransform = CGAffineTransform(
        translationX: 0,
        y: bottomViewStartTransform.ty + deltaY
      )
      let maxTranslation = -screenSize.height *
      (BottomSheetState.expanded.heightRatio - BottomSheetState.collapsed.heightRatio)
      
      let clampedTranslation = min(0, max(maxTranslation, newTransform.ty))
      bottomView.transform = CGAffineTransform(translationX: 0, y: clampedTranslation)
      updateMapLayoutMargins()
    case .ended, .cancelled:
      let velocity = gesture.velocity(in: self)
      snapToNearestDetent(withVelocity: velocity)
      
    default:
      break
    }
  }
  
  @objc
  private func myLocationButtonDidTapped() {
    mapView.setRegion(
      MKCoordinateRegion(
        center: mapView.userLocation.coordinate,
        latitudinalMeters: 100,
        longitudinalMeters: 100),
      animated: true)
  }
  
  private func snapToNearestDetent(withVelocity velocity: CGPoint) {
    let currentTranslation = bottomView.transform.ty
    let totalHeight = screenSize.height *
    (BottomSheetState.expanded.heightRatio - BottomSheetState.collapsed.heightRatio)
    let progress = abs(currentTranslation) / totalHeight
    
    let targetState = calculateTargetState(
      progress: progress,
      velocity: velocity,
      currentState: currentDetent
    )
    
    currentDetent = targetState
  }
  
  private func calculateTargetState(
    progress: CGFloat,
    velocity: CGPoint,
    currentState: BottomSheetState
  ) -> BottomSheetState {
    if abs(velocity.y) > 600 {
      if velocity.y > 0 {
        switch currentState {
        case .collapsed: return .collapsed
        case .partial: return .collapsed
        case .expanded: return .partial
        }
      } else {
        switch currentState {
        case .collapsed: return .partial
        case .partial: return .expanded
        case .expanded: return .expanded
        }
      }
    } else {
      if progress < 0.2 {
        return .collapsed
      } else if progress < 0.6 {
        return .partial
      } else {
        return .expanded
      }
    }
  }
  
  private func animateToState(_ state: BottomSheetState, withVelocity velocity: CGPoint) {
    let targetTranslation = -screenSize.height *
    (state.heightRatio - BottomSheetState.collapsed.heightRatio)
    
    UIView.animate(
      withDuration: 0.15,
      delay: 0,
      options: .curveEaseOut
    ) {
      self.bottomView.transform = CGAffineTransform(translationX: 0, y: targetTranslation)
      self.updateMapLayoutMargins()
    } completion: { _ in
      self.currentDetent = state
      self.generateHapticFeedback()
    }
  }
  
  private func updateMapLayoutMargins() {
    mapView.layoutMargins = UIEdgeInsets(
      top: 0,
      left: 0,
      bottom: screenSize.height - bottomView.frame.minY - 32,
      right: 0
    )
  }
  
  private func generateHapticFeedback() {
    let generator = UIImpactFeedbackGenerator(style: .medium)
    generator.prepare()
    generator.impactOccurred()
  }
  
  public func setDetent(_ state: BottomSheetState) {
    currentDetent = state
  }
  
  private func updateBottomSheetState(_ state: BottomSheetState) {
    if state != .expanded {
      tableView.setContentOffset(.zero, animated: true)
    }
    
    let targetTranslation = -screenSize.height *
    (state.heightRatio - BottomSheetState.collapsed.heightRatio)
    
    UIView.animate(
      withDuration: 0.15,
      delay: 0,
      options: .curveEaseOut
    ) {
      self.bottomView.transform = CGAffineTransform(
        translationX: 0,
        y: targetTranslation
      )
      self.updateMapLayoutMargins()
    } completion: { _ in
      self.generateHapticFeedback()
      self.bottomSheetStateSubject.onNext(state)
    }
  }
}

// MARK: - UIGestureRecognizerDelegate
extension HomeView: UIGestureRecognizerDelegate {
  public func gestureRecognizer(
    _ gestureRecognizer: UIGestureRecognizer,
    shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
  ) -> Bool {
    guard currentDetent == .expanded,
          tableView.contentOffset == .zero,
          gestureRecognizer == panGesture,
          otherGestureRecognizer == tableView.panGestureRecognizer else {
      return false
    }
    return true
  }
  
  public func gestureRecognizer(
    _ gestureRecognizer: UIGestureRecognizer,
    shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer
  ) -> Bool {
    if currentDetent != .expanded && gestureRecognizer == panGesture {
      return true
    }
    
    if currentDetent == .expanded &&
        tableView.contentOffset.y == 0 &&
        gestureRecognizer == tableView.panGestureRecognizer {
      let velocity = tableView.panGestureRecognizer.velocity(in: tableView)
      return velocity.y < 0
    }
    
    return false
  }
}

// MARK: - UITableViewDelegate, DataSource
extension HomeView: UITableViewDelegate, UITableViewDataSource {
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    stores.count
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "StoreCell") as? StoreCell else {
      fatalError()
    }
    
    cell.configure(with: stores[indexPath.row], rank: indexPath.row + 1)
    cell.animateScale(isDown: true, animated: false)
    cell.animateScale(isDown: false, delay: 0.1)
    return cell
  }
  
  public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    71
  }
  
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard currentDetent == .expanded else { return }
    tableView.isScrollEnabled = currentDetent == .expanded
    if scrollView.contentOffset.y <= 0 {
      // 스크롤이 최상단에 도달했을 때 bounce 효과 비활성화
      scrollView.bounces = false
    } else {
      scrollView.bounces = true
    }
  }
  
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard currentDetent == .expanded else { return }

    let store = stores[indexPath.row]
    
    isSetRegionFromTableView = true
    mapView.setRegion(
      MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: store.latitude, longitude: store.longitude),
        latitudinalMeters: 100,
        longitudinalMeters: 100),
      animated: true)
  }
}

// MARK: MKMapViewDelegate
extension HomeView: MKMapViewDelegate {
  public func mapView(
    _ mapView: MKMapView,
    viewFor annotation: any MKAnnotation
  ) -> MKAnnotationView? {
    // User Location에 대한 기본 Annotation 유지
    if annotation is MKUserLocation {
      return nil
    }
    
    guard let storeAnnotation = annotation as? StoreAnnotation else {
      return nil
    }
    
    let annotationView = mapView.dequeueReusableAnnotationView(
      withIdentifier: "StoreAnnotationView",
      for: annotation
    ) as! StoreAnnotationView
    
    annotationView.configure(with: storeAnnotation, rank: storeAnnotation.rank)
    annotationView.zPriority = .init(rawValue: 10 - Float(storeAnnotation.rank))
    
    return annotationView
  }
  
  public func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
    if currentDetent == .expanded {
      setDetent(.partial)
    }
  }
  
  public func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
    guard !isSetRegionFromTableView else {
      isSetRegionFromTableView = false
      return
    }
    
    self.coordinate.accept(mapView.centerCoordinate)
  }
}

#Preview {
  HomeView()
}
