// @generated
// This file was automatically generated and should not be edited.

@_exported import Apollo
import Rickandmortyexample

public class AutocompleteByCharacterSpeciesQuery: GraphQLQuery {
  public static let operationName: String = "AutocompleteByCharacterSpecies"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      query AutocompleteByCharacterSpecies($search: String!) {
        characters(page: 1, filter: {species: $search}) {
          __typename
          results {
            __typename
            species
          }
        }
      }
      """
    ))

  public var search: String

  public init(search: String) {
    self.search = search
  }

  public var __variables: Variables? { ["search": search] }

  public struct Data: Rickandmortyexample.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ParentType { Rickandmortyexample.Objects.Query }
    public static var __selections: [Selection] { [
      .field("characters", Characters?.self, arguments: [
        "page": 1,
        "filter": ["species": .variable("search")]
      ]),
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
          .field("species", String?.self),
        ] }

        /// The species of the character.
        public var species: String? { __data["species"] }
      }
    }
  }
}
