// @generated
// This file was automatically generated and should not be edited.

@_exported import Apollo
import Rickandmortyexample

public struct EpisodeSummaryFragment: Rickandmortyexample.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString { """
    fragment EpisodeSummaryFragment on Episode {
      __typename
      id
      name
      episode
      air_date
    }
    """ }

  public let __data: DataDict
  public init(data: DataDict) { __data = data }

  public static var __parentType: ParentType { Rickandmortyexample.Objects.Episode }
  public static var __selections: [Selection] { [
    .field("id", Rickandmortyexample.ID?.self),
    .field("name", String?.self),
    .field("episode", String?.self),
    .field("air_date", String?.self),
  ] }

  /// The id of the episode.
  public var id: Rickandmortyexample.ID? { __data["id"] }
  /// The name of the episode.
  public var name: String? { __data["name"] }
  /// The code of the episode.
  public var episode: String? { __data["episode"] }
  /// The air date of the episode.
  public var air_date: String? { __data["air_date"] }
}
