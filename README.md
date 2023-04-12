
# English Premier League App

This app displays information about the English Premier League. It includes a list of fixtures that can be filtered to show only the user's favorite matches. The app uses data from a JSON endpoint to display the fixtures.

## Features

### Fixtures List

The Fixtures List screen displays a list of matches. Each item shows the teams’ name and either the game result or the time of the game in hh:mm if it hasn't been played yet. The list is sectioned by day, and the first visible section of the list is either the current day or the next if there are no fixtures on the current day.

### Fixtures List

Users can toggle between showing the entire list and a subset of the list containing only their favorite fixtures. Users can mark fixtures as "favorite" using the control toggle provided.


## Installation

- Clone the repository using git clone:

```bash
 https://github.com/SherifKamalSalem/Premier-League.git
```

- Wait until Swift package manager load the packages then run the project

## Includes

* Using MVVM design pattern
* I implemented this task using `Combine framework` on these branches `feature/combine_create_presentation_layer_fixtures_list_scene` and `feature/combine_create_unit_testing`
* I implemented it also using `Async/Await` on this branch `feature/async_await_presentation_layer_fixtures_list_scene`
* Unit Tests for `FixturesListViewModel`
* Code styling standards.
* Applying Gitflow
* Save tokens securely in Keychain and encrypt it using sipher.
* Favorites fixtures persisted between app launches.
* Add localization to the project
* I hardcoded the competitionId `2021` just for simplicity but it supposed to be entered by the user


## Dependencies

- Moya
- [KeychainAccess](https://github.com/kishikawakatsumi/KeychainAccess)


## Optimisations/Additions (If I have more time)

  Optimisations  | Why I didn't prioritise it.
  ------------- | ----------------------------
  [Modularity](https://tech.olx.com/modular-architecture-in-ios-c1a1e3bff8e9)  |  Modularity is high priority especially for large scale projects but it's hard to be implemented from the beginning when the big picture isn't fully completed, for more details about modular architecture watch this https://www.youtube.com/watch?v=QzM3lsFewN4
  Setup CI/CD using Fastlane  |  Lower priority relative to other requirements.
Add Fixture Details screen  |  Lower priority relative to other requirements.
  Add custom transition animations   | Lower priority relative to other requirements.
  Improve UI design   | Lower priority relative to other requirements.



