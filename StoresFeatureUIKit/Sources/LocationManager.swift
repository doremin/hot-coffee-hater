//
//  LocationManager.swift
//  HotCoffeeHater
//
//  Created by doremin on 11/14/24.
//

import CoreLocation

import RxSwift
import RxCocoa

final class LocationManager: NSObject {
  // MARK: - Properties
  private let manager = CLLocationManager()
  
  let currentLocation = PublishRelay<CLLocationCoordinate2D>()
  let authorizationStatus = PublishRelay<CLAuthorizationStatus>()
  
  // MARK: - Initialization
  override init() {
    super.init()
    setupLocationManager()
  }
  
  // MARK: - Setup
  private func setupLocationManager() {
    manager.delegate = self
    manager.desiredAccuracy = kCLLocationAccuracyBest
  }
  
  // MARK: - Public Methods
  func requestAuthorization() {
    manager.requestWhenInUseAuthorization()
    manager.requestTemporaryFullAccuracyAuthorization(
      withPurposeKey: "LocationAccuracyRequest"
    )
  }
  
  func startUpdatingLocation() {
    manager.startUpdatingLocation()
  }
  
  func stopUpdatingLocation() {
    manager.stopUpdatingLocation()
  }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
  func locationManager(
    _ manager: CLLocationManager,
    didUpdateLocations locations: [CLLocation]
  ) {
    guard let location = locations.last else { return }
    currentLocation.accept(location.coordinate)
  }
  
  func locationManager(
    _ manager: CLLocationManager,
    didChangeAuthorization status: CLAuthorizationStatus
  ) {
    authorizationStatus.accept(status)
    
    switch status {
    case .authorizedWhenInUse, .authorizedAlways:
      startUpdatingLocation()
    case .denied, .restricted:
      break
    case .notDetermined:
      requestAuthorization()
    @unknown default:
      break
    }
  }
  
  func locationManager(
    _ manager: CLLocationManager,
    didFailWithError error: Error
  ) {
    print("Location Error: \(error.localizedDescription)")
  }
}
