//
//  HomeViewModelTests.swift
//  HotCoffeeHater
//
//  Created by doremin on 12/16/24.
//

import XCTest
import RxSwift
import RxTest
import RxCocoa
import MapKit
import StoresFeatureEntity
@testable import StoresFeatureUIKit

final class HomeViewModelTests: XCTestCase {
  // MARK: - Common Properties
  private var sut: HomeViewModel!
  private var disposeBag: DisposeBag!
  private var mockRepository: MockStoresRepository!
  
  // MARK: - Setup
  override func setUp() {
    super.setUp()
    self.mockRepository = MockStoresRepository()
    self.disposeBag = DisposeBag()
    self.sut = HomeViewModel(storesRepository: self.mockRepository)
  }
  
  // MARK: - Tear down
  override func tearDown() {
    sut = nil
    disposeBag = nil
    mockRepository = nil
    super.tearDown()
  }
  
  // MARK: - Helper Methods
  private func makeCoordinate() -> CLLocationCoordinate2D {
    CLLocationCoordinate2D(latitude: 37.6, longitude: 127.0)
  }
  
  private func makeExpectedStores() -> [StoreEntity] {
    StoreEntityFixture.createBulk(count: 1)
  }
  
  // MARK: - Tests
  @MainActor
  func test_repository_returns_stores() async {
    // Given
    let coordinate = PublishSubject<CLLocationCoordinate2D>()
    let expectedResults = makeExpectedStores()
    let expectation = expectation(description: "Stores fetched")
    mockRepository.stubbedResult = .success(expectedResults)
    
    var receivedStores: [StoreEntity]?
    
    // When
    let input = HomeViewModel.Input(coordinate: coordinate)
    let output = sut.transform(input: input)
    
    output.stores
      .drive(onNext: { stores in
        receivedStores = stores
        expectation.fulfill()
      })
      .disposed(by: disposeBag)
    
    coordinate.onNext(makeCoordinate())
    
    // Then
    await fulfillment(of: [expectation], timeout: 2.0)
    XCTAssertEqual(receivedStores, expectedResults)
  }
  
  // debounce가 600ms 이므로 fulfillment는 항상 실패해야함
  // expectation.isInverted = true로 설정해서 fulfill 되지 않아야 성공
  @MainActor
  func test_debounce_works() async {
    // Given
    let coordinate = PublishSubject<CLLocationCoordinate2D>()
    let expectation = expectation(description: "Stores fetched")
    expectation.isInverted = true
    mockRepository.stubbedResult = .success(makeExpectedStores())
    
    var receivedStores: [StoreEntity]?
    
    // When
    let input = HomeViewModel.Input(coordinate: coordinate)
    let output = sut.transform(input: input)
    
    output.stores
      .drive(onNext: { stores in
        receivedStores = stores
        expectation.fulfill()
      })
      .disposed(by: disposeBag)
    
    coordinate.onNext(makeCoordinate())
    
    // Then
    await fulfillment(of: [expectation], timeout: 0.5)
    XCTAssertNil(receivedStores)
  }
}
