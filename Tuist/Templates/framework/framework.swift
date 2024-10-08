import ProjectDescription

let exampleContents = """
import Foundation

"""

let testContents = """
import XCTest

"""

let nameAttribute: Template.Attribute = .required("name")

let template = Template(
  description: "Framework Template",
  attributes: [
    nameAttribute,
  ],
  items: [
    .string(
      path: "\(nameAttribute)/Sources/\(nameAttribute).swift",
      contents: exampleContents
    ),
    .string(
      path: "\(nameAttribute)/Tests/\(nameAttribute)Tests.swift",
      contents: testContents
    ),
    .string(
      path: "\(nameAttribute)/Resources/\(nameAttribute)Resources.swift",
      contents: testContents
    ),
  ]
)
