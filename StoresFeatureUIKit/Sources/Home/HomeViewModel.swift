//
//  HomeViewModel.swift
//  HotCoffeeHater
//
//  Created by doremin on 11/6/24.
//

import UIKit
import MapKit

import HotCoffeeHaterCore
import StoresFeatureEntity
import StoresFeatureRepository

import RxSwift
import RxCocoa

// MARK: - BottomSheetState
public enum BottomSheetState {
  case collapsed
  case partial
  case expanded
  
  public var heightRatio: CGFloat {
    switch self {
    case .collapsed:
      return 94 / screenSize.height // 94px을 %로 변환
    case .partial:
      return 0.3
    case .expanded:
      return 0.7
    }
  }
}

// MARK: - HomeViewModel
final public class HomeViewModel: ViewModelType {
  
  // MARK: - Input & Output
  public struct Input {
    let coordinate: Observable<CLLocationCoordinate2D>
  }
  
  public struct Output {
    let stores: Driver<[StoreEntity]>
    let isLoading: Driver<Bool>
    let error: Signal<APIError>
  }
  
  // MARK: - Properties
  private let disposeBag = DisposeBag()
  private let storesRepository: StoresRepository
  
  // MARK: Relays
  private let storesRelay = BehaviorRelay<[StoreEntity]>(value: [])
  private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
  private let errorRelay = PublishRelay<APIError>()
  
  
  // MARK: - Initializer
  public init(storesRepository: StoresRepository) {
    self.storesRepository = storesRepository
  }
  
  // MARK: - Transform
  public func transform(input: Input) -> Output {
    input.coordinate
      .do(onNext: { [weak self] _ in
        guard let self = self else {
          return
        }
        
        self.isLoadingRelay.accept(true)
      })
      .debounce(.microseconds(600), scheduler: MainScheduler.instance)
      .flatMapLatest { [weak self] location -> Observable<[StoreEntity]> in
        guard let self = self else {
          return .empty()
        }
        
        return self.fetchStores(location: location)
      }
      .do(onNext: { [weak self] _ in
        guard let self = self else {
          return
        }
        
        self.isLoadingRelay.accept(false)
      })
      .bind(to: storesRelay)
      .disposed(by: disposeBag)
    
    return Output(
      stores: storesRelay.asDriver(),
      isLoading: isLoadingRelay.asDriver(),
      error: errorRelay.asSignal())
  }
  
  private func fetchStores(location: CLLocationCoordinate2D) -> Observable<[StoreEntity]> {
    Observable.create { [weak self] observer in
      guard let self = self else {
        return Disposables.create()
      }
      
      Task {
        do {
          let stores = try await self.storesRepository.getStores(
            latitude: location.latitude,
            longitude: location.longitude)
          observer.onNext(stores)
          observer.onCompleted()
        } catch let error as APIError {
          self.errorRelay.accept(error)
        }
      }
      
      return Disposables.create()
    }
  }
  
}
