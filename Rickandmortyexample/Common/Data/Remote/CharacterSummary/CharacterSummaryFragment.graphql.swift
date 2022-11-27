// @generated
// This file was automatically generated and should not be edited.

@_exported import Apollo
import Rickandmortyexample

public struct CharacterSummaryFragment: Rickandmortyexample.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString { """
    fragment CharacterSummaryFragment on Character {
      __typename
      id
      name
      image
      status
    }
    """ }

  public let __data: DataDict
  public init(data: DataDict) { __data = data }

  public static var __parentType: ParentType { Rickandmortyexample.Objects.Character }
  public static var __selections: [Selection] { [
    .field("id", Rickandmortyexample.ID?.self),
    .field("name", String?.self),
    .field("image", String?.self),
    .field("status", String?.self),
  ] }

  /// The id of the character.
  public var id: Rickandmortyexample.ID? { __data["id"] }
  /// The name of the character.
  public var name: String? { __data["name"] }
  /// Link to the character's image.
  /// All images are 300x300px and most are medium shots or portraits since they are intended to be used as avatars.
  public var image: String? { __data["image"] }
  /// The status of the character ('Alive', 'Dead' or 'unknown').
  public var status: String? { __data["status"] }
}
