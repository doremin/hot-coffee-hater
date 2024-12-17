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
  private let scheduler: SchedulerType
  
  // MARK: Relays
  private let storesRelay = PublishRelay<[StoreEntity]>()
  private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
  private let errorRelay = PublishRelay<APIError>()
  
  
  // MARK: - Initializer
  public init(storesRepository: StoresRepository, scheduler: SchedulerType = MainScheduler.instance) {
    self.storesRepository = storesRepository
    self.scheduler = scheduler
  }
  
  // MARK: - Transform
  public func transform(input: Input) -> Output {
    input.coordinate
      .observe(on: scheduler)
      .do(onNext: { [weak self] _ in
        guard let self = self else {
          return
        }
        self.isLoadingRelay.accept(true)
      })
      .debounce(.milliseconds(600), scheduler: scheduler)
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
      stores: storesRelay.asDriver(onErrorJustReturn: []),
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
