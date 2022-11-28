// @generated
// This file was automatically generated and should not be edited.

import Apollo

public struct FilterEpisode: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    name: GraphQLNullable<String> = nil,
    episode: GraphQLNullable<String> = nil
  ) {
    __data = InputDict([
      "name": name,
      "episode": episode
    ])
  }

  public var name: GraphQLNullable<String> {
    get { __data["name"] }
    set { __data["name"] = newValue }
  }

  public var episode: GraphQLNullable<String> {
    get { __data["episode"] }
    set { __data["episode"] = newValue }
  }
}
