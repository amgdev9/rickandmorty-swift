// @generated
// This file was automatically generated and should not be edited.

import Apollo

public struct FilterCharacter: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    name: GraphQLNullable<String> = nil,
    status: GraphQLNullable<String> = nil,
    species: GraphQLNullable<String> = nil,
    type: GraphQLNullable<String> = nil,
    gender: GraphQLNullable<String> = nil
  ) {
    __data = InputDict([
      "name": name,
      "status": status,
      "species": species,
      "type": type,
      "gender": gender
    ])
  }

  public var name: GraphQLNullable<String> {
    get { __data["name"] }
    set { __data["name"] = newValue }
  }

  public var status: GraphQLNullable<String> {
    get { __data["status"] }
    set { __data["status"] = newValue }
  }

  public var species: GraphQLNullable<String> {
    get { __data["species"] }
    set { __data["species"] = newValue }
  }

  public var type: GraphQLNullable<String> {
    get { __data["type"] }
    set { __data["type"] = newValue }
  }

  public var gender: GraphQLNullable<String> {
    get { __data["gender"] }
    set { __data["gender"] = newValue }
  }
}
