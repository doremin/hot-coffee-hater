//
//  ViewModelType.swift
//  HotCoffeeHater
//
//  Created by doremin on 11/6/24.
//

public protocol ViewModelType {
  associatedtype Input
  associatedtype Output
  
  func transform(input: Input) -> Output
}
