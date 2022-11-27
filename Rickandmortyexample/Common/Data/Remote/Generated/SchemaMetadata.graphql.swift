// @generated
// This file was automatically generated and should not be edited.

import Apollo

public typealias ID = String

public protocol SelectionSet: Apollo.SelectionSet & Apollo.RootSelectionSet
where Schema == Rickandmortyexample.SchemaMetadata {}

public protocol InlineFragment: Apollo.SelectionSet & Apollo.InlineFragment
where Schema == Rickandmortyexample.SchemaMetadata {}

public protocol MutableSelectionSet: Apollo.MutableRootSelectionSet
where Schema == Rickandmortyexample.SchemaMetadata {}

public protocol MutableInlineFragment: Apollo.MutableSelectionSet & Apollo.InlineFragment
where Schema == Rickandmortyexample.SchemaMetadata {}

public enum SchemaMetadata: Apollo.SchemaMetadata {
  public static let configuration: Apollo.SchemaConfiguration.Type = SchemaConfiguration.self

  public static func objectType(forTypename typename: String) -> Object? {
    switch typename {
    case "Query": return Rickandmortyexample.Objects.Query
    case "Character": return Rickandmortyexample.Objects.Character
    case "Location": return Rickandmortyexample.Objects.Location
    case "Episode": return Rickandmortyexample.Objects.Episode
    case "Characters": return Rickandmortyexample.Objects.Characters
    case "Info": return Rickandmortyexample.Objects.Info
    case "Locations": return Rickandmortyexample.Objects.Locations
    default: return nil
    }
  }
}

public enum Objects {}
public enum Interfaces {}
public enum Unions {}
