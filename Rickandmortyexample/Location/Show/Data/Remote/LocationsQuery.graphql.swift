// @generated
// This file was automatically generated and should not be edited.

@_exported import Apollo
import Rickandmortyexample

public class LocationsQuery: GraphQLQuery {
  public static let operationName: String = "Locations"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      query Locations($page: Int!, $filter: FilterLocation!) {
        locations(page: $page, filter: $filter) {
          __typename
          results {
            __typename
            ...LocationSummaryFragment
          }
          info {
            __typename
            pages
          }
        }
      }
      """,
      fragments: [LocationSummaryFragment.self]
    ))

  public var page: Int
  public var filter: Rickandmortyexample.FilterLocation

  public init(
    page: Int,
    filter: Rickandmortyexample.FilterLocation
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
      .field("locations", Locations?.self, arguments: [
        "page": .variable("page"),
        "filter": .variable("filter")
      ]),
    ] }

    /// Get the list of all locations
    public var locations: Locations? { __data["locations"] }

    /// Locations
    ///
    /// Parent Type: `Locations`
    public struct Locations: Rickandmortyexample.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { Rickandmortyexample.Objects.Locations }
      public static var __selections: [Selection] { [
        .field("results", [Result?]?.self),
        .field("info", Info?.self),
      ] }

      public var results: [Result?]? { __data["results"] }
      public var info: Info? { __data["info"] }

      /// Locations.Result
      ///
      /// Parent Type: `Location`
      public struct Result: Rickandmortyexample.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ParentType { Rickandmortyexample.Objects.Location }
        public static var __selections: [Selection] { [
          .fragment(LocationSummaryFragment.self),
        ] }

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
      }

      /// Locations.Info
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
