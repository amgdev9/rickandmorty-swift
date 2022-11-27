// @generated
// This file was automatically generated and should not be edited.

@_exported import Apollo
import Rickandmortyexample

public struct CharacterLocationFragment: Rickandmortyexample.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString { """
    fragment CharacterLocationFragment on Location {
      __typename
      id
      name
    }
    """ }

  public let __data: DataDict
  public init(data: DataDict) { __data = data }

  public static var __parentType: ParentType { Rickandmortyexample.Objects.Location }
  public static var __selections: [Selection] { [
    .field("id", Rickandmortyexample.ID?.self),
    .field("name", String?.self),
  ] }

  /// The id of the location.
  public var id: Rickandmortyexample.ID? { __data["id"] }
  /// The name of the location.
  public var name: String? { __data["name"] }
}
