// @generated
// This file was automatically generated and should not be edited.

@_exported import Apollo
import Rickandmortyexample

public class EpisodeDetailQuery: GraphQLQuery {
  public static let operationName: String = "EpisodeDetail"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      query EpisodeDetail($id: ID!) {
        episode(id: $id) {
          __typename
          ...EpisodeSummaryFragment
          characters {
            __typename
            ...CharacterSummaryFragment
          }
        }
      }
      """,
      fragments: [EpisodeSummaryFragment.self, CharacterSummaryFragment.self]
    ))

  public var id: Rickandmortyexample.ID

  public init(id: Rickandmortyexample.ID) {
    self.id = id
  }

  public var __variables: Variables? { ["id": id] }

  public struct Data: Rickandmortyexample.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ParentType { Rickandmortyexample.Objects.Query }
    public static var __selections: [Selection] { [
      .field("episode", Episode?.self, arguments: ["id": .variable("id")]),
    ] }

    /// Get a specific episode by ID
    public var episode: Episode? { __data["episode"] }

    /// Episode
    ///
    /// Parent Type: `Episode`
    public struct Episode: Rickandmortyexample.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { Rickandmortyexample.Objects.Episode }
      public static var __selections: [Selection] { [
        .field("characters", [Character?].self),
        .fragment(EpisodeSummaryFragment.self),
      ] }

      /// List of characters who have been seen in the episode.
      public var characters: [Character?] { __data["characters"] }
      /// The id of the episode.
      public var id: Rickandmortyexample.ID? { __data["id"] }
      /// The name of the episode.
      public var name: String? { __data["name"] }
      /// The code of the episode.
      public var episode: String? { __data["episode"] }
      /// The air date of the episode.
      public var air_date: String? { __data["air_date"] }

      public struct Fragments: FragmentContainer {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public var episodeSummaryFragment: EpisodeSummaryFragment { _toFragment() }
      }

      /// Episode.Character
      ///
      /// Parent Type: `Character`
      public struct Character: Rickandmortyexample.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ParentType { Rickandmortyexample.Objects.Character }
        public static var __selections: [Selection] { [
          .fragment(CharacterSummaryFragment.self),
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

        public struct Fragments: FragmentContainer {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public var characterSummaryFragment: CharacterSummaryFragment { _toFragment() }
        }
      }
    }
  }
}
