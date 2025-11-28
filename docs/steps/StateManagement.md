# State Management with [Riverpod](https://riverpod.dev/docs/introduction/getting_started)

[![Riverpod](https://i.ytimg.com/vi_webp/BJtQ0dfI-RA/sddefault.webp)](https://www.youtube.com/watch?v=BJtQ0dfI-RA)

## Install riverpod

* flutter pub add flutter_riverpod
* flutter pub add riverpod_annotation
* flutter pub add dev:riverpod_generator
* flutter pub add dev:build_runner
* flutter pub add dev:custom_lint
* flutter pub add dev:riverpod_lint

```code
###Enabling riverpod_lint/custom_lint : add to analysis_options.yaml

analyzer:
  plugins:
    - custom_lint
```

### Setting up ProviderScope

Before we start making network requests, make sure that ProviderScope is added at the root of the application.

```dart
void main() {
  runApp(
    // To install Riverpod, we need to add this widget above everything else.
    // This should not be inside "MyApp" but as direct parameter to "runApp".
    ProviderScope(
      child: MyApp(),
    ),
  );
}
```

In Riverpod, business logic is placed inside "providers".
A provider is a super-powered function. They behave like normal functions, with the added benefits of:

* being cached
* offering default error/loading handling
* being listenable
* automatically re-executing when some data changes

### Types of Provider

* [Provider](https://riverpod.dev/docs/providers/provider)
  
  Provider is the most basic of all providers. It creates a value... And that's about it.

  Provider is typically used for:

  caching computations
  exposing a value to other providers (such as a Repository/HttpClient).
  offering a way for tests or widgets to override a value.
  reducing rebuilds of providers/widgets without having to use select.

* [(Async)NotifierProvider](https://riverpod.dev/docs/providers/notifier_provider)

  NotifierProvider is a provider that is used to listen to and expose a Notifier.
  AsyncNotifierProvider is a provider that is used to listen to and expose an AsyncNotifier. AsyncNotifier is a Notifier that can be asynchronously initialized.
  (Async)NotifierProvider along with (Async)Notifier is Riverpod's recommended solution for managing state which may change in reaction to a user interaction.

  It is typically used for:

  exposing a state which can change over time after reacting to custom events.
  centralizing the logic for modifying some state (aka "business logic") in a single place, improving maintainability over time

* [FutureProvider](https://riverpod.dev/docs/providers/future_provider)

  FutureProvider is the equivalent of Provider but for asynchronous code.

  FutureProvider is typically used for:

  performing and caching asynchronous operations (such as network requests)
  nicely handling error/loading states of asynchronous operations
  combining multiple asynchronous values into another value

* [StreamProvider](https://riverpod.dev/docs/providers/stream_provider)

  StreamProvider is similar to FutureProvider but for Streams instead of Futures.

### [Creating the Provider](https://riverpod.dev/docs/essentials/first_request#creating-the-provider)

### [Ref : Combining requests](https://riverpod.dev/docs/essentials/combining_requests)

### [Reading a Provider](https://riverpod.dev/docs/concepts/reading)

### [Clearing cache and reacting to state disposal](https://riverpod.dev/docs/essentials/auto_dispose)

---

### [Logging and error reporting](https://riverpod.dev/docs/essentials/provider_observer)

### [Scopes](https://riverpod.dev/docs/concepts/scopes)

### [Provider Lifecycles](https://riverpod.dev/docs/concepts/provider_lifecycles)

### [About code generation](https://riverpod.dev/docs/concepts/about_code_generation)

  ```code
  ### cli to generate riverpod files

  dart run build_runner watch --delete-conflicting-outputs
  ```

### [Hooks](https://riverpod.dev/docs/concepts/about_hooks)

### [Flutter_Hooks](https://pub.dev/packages/flutter_hooks)

flutter pub add flutter_hooks
