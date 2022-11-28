// @generated
// This file was automatically generated and should not be edited.

@_exported import Apollo
import Rickandmortyexample

public class AutocompleteByLocationDimensionQuery: GraphQLQuery {
  public static let operationName: String = "AutocompleteByLocationDimension"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      query AutocompleteByLocationDimension($search: String!) {
        locations(page: 1, filter: {dimension: $search}) {
          __typename
          results {
            __typename
            dimension
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
      .field("locations", Locations?.self, arguments: [
        "page": 1,
        "filter": ["dimension": .variable("search")]
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
      ] }

      public var results: [Result?]? { __data["results"] }

      /// Locations.Result
      ///
      /// Parent Type: `Location`
      public struct Result: Rickandmortyexample.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ParentType { Rickandmortyexample.Objects.Location }
        public static var __selections: [Selection] { [
          .field("dimension", String?.self),
        ] }

        /// The dimension in which the location is located.
        public var dimension: String? { __data["dimension"] }
      }
    }
  }
}
