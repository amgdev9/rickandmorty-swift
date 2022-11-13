// @generated
// This file was automatically generated and should not be edited.

@_exported import Apollo
import Rickandmortyexample

public class CharactersQuery: GraphQLQuery {
  public static let operationName: String = "Characters"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      query Characters {
        characters(page: 1) {
          __typename
          results {
            __typename
            id
            name
          }
        }
      }
      """
    ))

  public init() {}

  public struct Data: Rickandmortyexample.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ParentType { Rickandmortyexample.Objects.Query }
    public static var __selections: [Selection] { [
      .field("characters", Characters?.self, arguments: ["page": 1]),
    ] }

    /// Get the list of all characters
    public var characters: Characters? { __data["characters"] }

    /// Characters
    ///
    /// Parent Type: `Characters`
    public struct Characters: Rickandmortyexample.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { Rickandmortyexample.Objects.Characters }
      public static var __selections: [Selection] { [
        .field("results", [Result?]?.self),
      ] }

      public var results: [Result?]? { __data["results"] }

      /// Characters.Result
      ///
      /// Parent Type: `Character`
      public struct Result: Rickandmortyexample.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ParentType { Rickandmortyexample.Objects.Character }
        public static var __selections: [Selection] { [
          .field("id", Rickandmortyexample.ID?.self),
          .field("name", String?.self),
        ] }

        /// The id of the character.
        public var id: Rickandmortyexample.ID? { __data["id"] }
        /// The name of the character.
        public var name: String? { __data["name"] }
      }
    }
  }
}
