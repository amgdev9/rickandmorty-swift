// @generated
// This file was automatically generated and should not be edited.

@_exported import Apollo
import Rickandmortyexample

public class AutocompleteByEpisodeSeasonIDQuery: GraphQLQuery {
  public static let operationName: String = "AutocompleteByEpisodeSeasonID"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      query AutocompleteByEpisodeSeasonID($search: String!) {
        episodes(page: 1, filter: {episode: $search}) {
          __typename
          results {
            __typename
            episode
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
        "filter": ["episode": .variable("search")]
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
          .field("episode", String?.self),
        ] }

        /// The code of the episode.
        public var episode: String? { __data["episode"] }
      }
    }
  }
}
