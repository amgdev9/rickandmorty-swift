// @generated
// This file was automatically generated and should not be edited.

@_exported import Apollo
import Rickandmortyexample

public class LocationDetailQuery: GraphQLQuery {
  public static let operationName: String = "LocationDetail"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      query LocationDetail($id: ID!) {
        location(id: $id) {
          __typename
          ...LocationSummaryFragment
          dimension
          residents {
            __typename
            ...CharacterSummaryFragment
          }
        }
      }
      """,
      fragments: [LocationSummaryFragment.self, CharacterSummaryFragment.self]
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
      .field("location", Location?.self, arguments: ["id": .variable("id")]),
    ] }

    /// Get a specific locations by ID
    public var location: Location? { __data["location"] }

    /// Location
    ///
    /// Parent Type: `Location`
    public struct Location: Rickandmortyexample.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { Rickandmortyexample.Objects.Location }
      public static var __selections: [Selection] { [
        .field("dimension", String?.self),
        .field("residents", [Resident?].self),
        .fragment(LocationSummaryFragment.self),
      ] }

      /// The dimension in which the location is located.
      public var dimension: String? { __data["dimension"] }
      /// List of characters who have been last seen in the location.
      public var residents: [Resident?] { __data["residents"] }
      /// The id of the location.
      public var id: Rickandmortyexample.ID? { __data["id"] }
      /// The name of the location.
      public var name: String? { __data["name"] }
      /// The type of the location.
      public var type: String? { __data["type"] }

      public struct Fragments: FragmentContainer {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public var locationSummaryFragment: LocationSummaryFragment { _toFragment() }
      }

      /// Location.Resident
      ///
      /// Parent Type: `Character`
      public struct Resident: Rickandmortyexample.SelectionSet {
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
