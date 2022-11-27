// @generated
// This file was automatically generated and should not be edited.

import Apollo

public struct FilterLocation: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    name: GraphQLNullable<String> = nil,
    type: GraphQLNullable<String> = nil,
    dimension: GraphQLNullable<String> = nil
  ) {
    __data = InputDict([
      "name": name,
      "type": type,
      "dimension": dimension
    ])
  }

  public var name: GraphQLNullable<String> {
    get { __data["name"] }
    set { __data["name"] = newValue }
  }

  public var type: GraphQLNullable<String> {
    get { __data["type"] }
    set { __data["type"] = newValue }
  }

  public var dimension: GraphQLNullable<String> {
    get { __data["dimension"] }
    set { __data["dimension"] = newValue }
  }
}
