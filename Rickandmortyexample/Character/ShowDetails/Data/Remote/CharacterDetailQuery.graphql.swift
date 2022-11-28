// @generated
// This file was automatically generated and should not be edited.

@_exported import Apollo
import Rickandmortyexample

public class CharacterDetailQuery: GraphQLQuery {
  public static let operationName: String = "CharacterDetail"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      query CharacterDetail($id: ID!) {
        character(id: $id) {
          __typename
          ...CharacterSummaryFragment
          gender
          species
          type
          origin {
            __typename
            ...CharacterLocationFragment
          }
          location {
            __typename
            ...CharacterLocationFragment
          }
          episode {
            __typename
            ...EpisodeSummaryFragment
          }
        }
      }
      """,
      fragments: [CharacterSummaryFragment.self, CharacterLocationFragment.self, EpisodeSummaryFragment.self]
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
      .field("character", Character?.self, arguments: ["id": .variable("id")]),
    ] }

    /// Get a specific character by ID
    public var character: Character? { __data["character"] }

    /// Character
    ///
    /// Parent Type: `Character`
    public struct Character: Rickandmortyexample.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { Rickandmortyexample.Objects.Character }
      public static var __selections: [Selection] { [
        .field("gender", String?.self),
        .field("species", String?.self),
        .field("type", String?.self),
        .field("origin", Origin?.self),
        .field("location", Location?.self),
        .field("episode", [Episode?].self),
        .fragment(CharacterSummaryFragment.self),
      ] }

      /// The gender of the character ('Female', 'Male', 'Genderless' or 'unknown').
      public var gender: String? { __data["gender"] }
      /// The species of the character.
      public var species: String? { __data["species"] }
      /// The type or subspecies of the character.
      public var type: String? { __data["type"] }
      /// The character's origin location
      public var origin: Origin? { __data["origin"] }
      /// The character's last known location
      public var location: Location? { __data["location"] }
      /// Episodes in which this character appeared.
      public var episode: [Episode?] { __data["episode"] }
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

      /// Character.Origin
      ///
      /// Parent Type: `Location`
      public struct Origin: Rickandmortyexample.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ParentType { Rickandmortyexample.Objects.Location }
        public static var __selections: [Selection] { [
          .fragment(CharacterLocationFragment.self),
        ] }

        /// The id of the location.
        public var id: Rickandmortyexample.ID? { __data["id"] }
        /// The name of the location.
        public var name: String? { __data["name"] }

        public struct Fragments: FragmentContainer {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public var characterLocationFragment: CharacterLocationFragment { _toFragment() }
        }
      }

      /// Character.Location
      ///
      /// Parent Type: `Location`
      public struct Location: Rickandmortyexample.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ParentType { Rickandmortyexample.Objects.Location }
        public static var __selections: [Selection] { [
          .fragment(CharacterLocationFragment.self),
        ] }

        /// The id of the location.
        public var id: Rickandmortyexample.ID? { __data["id"] }
        /// The name of the location.
        public var name: String? { __data["name"] }

        public struct Fragments: FragmentContainer {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public var characterLocationFragment: CharacterLocationFragment { _toFragment() }
        }
      }

      /// Character.Episode
      ///
      /// Parent Type: `Episode`
      public struct Episode: Rickandmortyexample.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ParentType { Rickandmortyexample.Objects.Episode }
        public static var __selections: [Selection] { [
          .fragment(EpisodeSummaryFragment.self),
        ] }

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
      }
    }
  }
}
