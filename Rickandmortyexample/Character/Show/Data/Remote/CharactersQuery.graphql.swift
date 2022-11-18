// @generated
// This file was automatically generated and should not be edited.

@_exported import Apollo
import Rickandmortyexample

public class CharactersQuery: GraphQLQuery {
  public static let operationName: String = "Characters"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      query Characters($page: Int!) {
        characters(page: $page) {
          __typename
          results {
            __typename
            id
            name
            image
            status
          }
          info {
            __typename
            pages
          }
        }
      }
      """
    ))

  public var page: Int

  public init(page: Int) {
    self.page = page
  }

  public var __variables: Variables? { ["page": page] }

  public struct Data: Rickandmortyexample.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ParentType { Rickandmortyexample.Objects.Query }
    public static var __selections: [Selection] { [
      .field("characters", Characters?.self, arguments: ["page": .variable("page")]),
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
        .field("info", Info?.self),
      ] }

      public var results: [Result?]? { __data["results"] }
      public var info: Info? { __data["info"] }

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

      /// Characters.Info
      ///
      /// Parent Type: `Info`
      public struct Info: Rickandmortyexample.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ParentType { Rickandmortyexample.Objects.Info }
        public static var __selections: [Selection] { [
          .field("pages", Int?.self),
        ] }

        /// The amount of pages.
        public var pages: Int? { __data["pages"] }
      }
    }
  }
}
