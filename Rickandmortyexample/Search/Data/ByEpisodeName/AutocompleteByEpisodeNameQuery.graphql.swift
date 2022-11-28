// @generated
// This file was automatically generated and should not be edited.

@_exported import Apollo
import Rickandmortyexample

public class AutocompleteByEpisodeNameQuery: GraphQLQuery {
  public static let operationName: String = "AutocompleteByEpisodeName"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      query AutocompleteByEpisodeName($search: String!) {
        episodes(page: 1, filter: {name: $search}) {
          __typename
          results {
            __typename
            name
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
      .field("episodes", Episodes?.self, arguments: [
        "page": 1,
        "filter": ["name": .variable("search")]
      ]),
    ] }

    /// Get the list of all episodes
    public var episodes: Episodes? { __data["episodes"] }

    /// Episodes
    ///
    /// Parent Type: `Episodes`
    public struct Episodes: Rickandmortyexample.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { Rickandmortyexample.Objects.Episodes }
      public static var __selections: [Selection] { [
        .field("results", [Result?]?.self),
      ] }

      public var results: [Result?]? { __data["results"] }

      /// Episodes.Result
      ///
      /// Parent Type: `Episode`
      public struct Result: Rickandmortyexample.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ParentType { Rickandmortyexample.Objects.Episode }
        public static var __selections: [Selection] { [
          .field("name", String?.self),
        ] }

        /// The name of the episode.
        public var name: String? { __data["name"] }
      }
    }
  }
}
