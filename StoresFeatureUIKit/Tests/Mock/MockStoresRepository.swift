//
//  MockStoresRepository.swift
//  HotCoffeeHater
//
//  Created by doremin on 12/16/24.
//

import StoresFeatureRepository
import StoresFeatureEntity
import RxCocoa
import RxSwift

final class MockStoresRepository: StoresRepository {
  
  var stubbedResult: Result<[StoreEntity], Error>!
  private let callCountRealy = BehaviorRelay(value: 0)
  
  var getStoresCallCount: Observable<Int> {
    callCountRealy.asObservable()
  }
  
  func getStores(latitude: Double, longitude: Double) async throws -> [StoreEntity] {
    switch stubbedResult! {
    case .success(let stores):
      return stores
    case .failure(let error):
      throw error
    }
  }
}
