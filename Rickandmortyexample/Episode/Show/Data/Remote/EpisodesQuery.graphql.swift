// @generated
// This file was automatically generated and should not be edited.

@_exported import Apollo
import Rickandmortyexample

public class EpisodesQuery: GraphQLQuery {
  public static let operationName: String = "Episodes"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      query Episodes($page: Int!, $filter: FilterEpisode!) {
        episodes(page: $page, filter: $filter) {
          __typename
          results {
            __typename
            ...EpisodeSummaryFragment
          }
          info {
            __typename
            next
          }
        }
      }
      """,
      fragments: [EpisodeSummaryFragment.self]
    ))

  public var page: Int
  public var filter: Rickandmortyexample.FilterEpisode

  public init(
    page: Int,
    filter: Rickandmortyexample.FilterEpisode
  ) {
    self.page = page
    self.filter = filter
  }

  public var __variables: Variables? { [
    "page": page,
    "filter": filter
  ] }

  public struct Data: Rickandmortyexample.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ParentType { Rickandmortyexample.Objects.Query }
    public static var __selections: [Selection] { [
      .field("episodes", Episodes?.self, arguments: [
        "page": .variable("page"),
        "filter": .variable("filter")
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
        .field("info", Info?.self),
      ] }

      public var results: [Result?]? { __data["results"] }
      public var info: Info? { __data["info"] }

      /// Episodes.Result
      ///
      /// Parent Type: `Episode`
      public struct Result: Rickandmortyexample.SelectionSet {
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

      /// Episodes.Info
      ///
      /// Parent Type: `Info`
      public struct Info: Rickandmortyexample.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ParentType { Rickandmortyexample.Objects.Info }
        public static var __selections: [Selection] { [
          .field("next", Int?.self),
        ] }

        /// Number of the next page (if it exists)
        public var next: Int? { __data["next"] }
      }
    }
  }
}
