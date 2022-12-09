# Rick and Morty Example App (iOS)
This project is a showcase on how to create a mobile application for the iOS platform using software engineering architectural principles and a reactive data flow to make our app scalable, maintainable, easy to test and resilient over time.

[![Demo](https://user-images.githubusercontent.com/37532652/206702291-f4d59725-f175-4693-af28-dd15120221ff.jpg)](https://user-images.githubusercontent.com/37532652/206701682-91a7fa9b-b738-410a-9aae-bfd2e6d13560.mp4)

## Libraries and frameworks
- User Interface: [SwiftUI](https://developer.apple.com/xcode/swiftui/)
- Database: [Realm](https://www.mongodb.com/docs/realm/sdk/swift/)
- Network client: [Apollo Client](https://www.apollographql.com/docs/ios/)
- Dependency injection: [Needle](https://github.com/uber/needle)
- Observables/reactivity: [RxSwift](https://github.com/ReactiveX/RxSwift)

## Development tools
- Linter: [SwiftLint](https://github.com/realm/SwiftLint)

## Utility libraries
- [AlertToast](https://github.com/elai950/AlertToast)

## Architecture overview

We can view our app as a series of loosely coupled features related to a specific domain entity. In the first folder levels of the project, we should be able to see the main entities which conform the application, so we can get a quick grasp of what the application is about. This way of structuring the folder hierarchy is often known as [Screaming Architecture](https://levelup.gitconnected.com/what-is-screaming-architecture-f7c327af9bb2).

### Organization by features

![Feature organization](https://user-images.githubusercontent.com/37532652/206708745-7582f166-3934-41df-a590-abc698227fe8.svg)

For each domain entity, we have a series of features which should be as independent as possible. However, there is always a chance to share code between them, and that's where the _Common code_ module comes into play. 

In this module, we allow each related feature to reference it, but it cannot be referenced by other entities or features that are not related by the same parent entity. This allows us to improve scalability as we don't have a global _Common_ or _Utils_ folder which would grow without control otherwise.

This organization is meant to be flexible, so we can have sub-features which depend on a parent feature, entities which are related to bigger-scoped entities, and so on. We can see its benefits when, for example, we want to search for something, as we always begin going through the more general entities, up to finding more concrete pieces of code as we navigate further in the folder hierarchy.

This is also powerful when we want to refactor, as we can move related pieces of code altogether without losing cohesion. Say that we want to increase a function scope so it can be reused by other features, in this case we would only need to move it up in the folder structure. If we need to shorten the scope, we need to go deeper in it.

In summary, this folder structure follows the level of abstraction.

### Layered Architecture

We have taken a layered architecture approach for this project:

![Feature layers](https://user-images.githubusercontent.com/37532652/206708159-9e31b195-d4df-4adf-9331-d82db20e4275.svg)

Some layers have been defined so code that is related in a specific part of the data flow would be together in the same layer.

Here we follow the [Dependency Rule](https://khalilstemmler.com/wiki/dependency-rule/), so that layers closer to the domain must not know anything about layers in the infrastructure. For example, code in the domain layer must not reference the user interface, but the user interface can reference from the presentation layer and beyond up to the domain layer.

- __Domain layer__: these are plain old objects defining the data structures which hold the information needed for this feature. In this project, we have taken an immutable approach, so each domain entity is unable to be changed by itself. A new entity must be created if a change is made in the state of the system, making the state transitions more specific and traceable, avoiding sources of bugs when implementing state logic and validation.

- __Application logic layer (_optional_)__: this layer implements some use cases which depend solely on domain entities. In this project we barely have logic of this kind, so we have removed this layer from the equation. If the project grows in size, this layer must be used so the presentation layer does not hold more than one responsibility. Also, this is the ideal place for data repositories to be called.

- __Presentation layer__: its purpose is to call the needed use cases for a feature and adapt the resulting information to a _View model_ which will be used by the User Interface layer to render for the final user. It is also the receiver of User Interface events, which will trigger the execution of application logic.

- __User Interface layer__: its aim is to take the computed _View Model_ from the Presentation layer to render it. It also produces input events (such as button presses, touch events and so on) for the Presentation layer. It also handles stuff like animations and transitions. This layer is usually implemented using a UI Framework. In this project, we are using SwiftUI for this.

- __Data repositories layer__: here we implement the adapters which take care of retrieving information from data sources and modifying the app state according to some data management rules. In this layer, we should implement the logic related to using the correct data source when needed according to some policy. For example, deciding whether to make a network request or retrieving data from a cache is the kind of logic which should appear in a repository

- __Data sources__: these are Data Access Objects (_DAOs_) which take care of retrieving and writing data to some infrastructure element which our application relies on. In this application we are using 2 types of data sources: a _remote data source_ which retrieves data from a remote server, and a _local data source_ which transfers data from a local database, mainly used to reduce the number of network requests. They need a repository to orchestrate when each data source should be used.

## Other patterns
For further reference, here we have some links describing other patterns and techniques used in this project:
- [Unidirectional Data Flow](https://www.geeksforgeeks.org/unidirectional-data-flow/)
- [MVI Pattern](https://www.youtube.com/watch?v=lNqCe0zbyLY): It's in Spanish, but it's really worth watching it
- [Dependency Injection](https://www.freecodecamp.org/news/a-quick-intro-to-dependency-injection-what-it-is-and-when-to-use-it-7578c84fa88f/)
- [Android Architecture Guide](https://developer.android.com/topic/architecture): the architecture shown here is based on this guide
- [Clean Architecture](https://www.amazon.com/Clean-Architecture-Craftsmans-Software-Structure/dp/0134494164): although we are not following it in a pragmatic way in this project, we apply most of the concepts which appear in this book
