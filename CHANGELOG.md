## [1.11.3]

#### Bug Fixes

- Fixed email subject formatting for feedback actions.

## [1.11.2]

#### Improvements

- Added fading edges to scrollable level, about, and story screens.
- Added spring press animations for level tiles, app bar buttons, game controls, and side menu items.
- Fixed app bar color changes while scrolling.

#### Technical Improvements

- Updated package dependencies.
- Migrated iOS plugin integration from CocoaPods to Swift Package Manager.
- Raised the iOS deployment target to 15.0 for current Xcode compatibility.
- Updated Gradle, Android Gradle Plugin, and Kotlin versions.

## [1.11.1]

#### Technical Improvements

- Updated package dependencies.

## [1.11.0]

#### New Features

- Added 10 new game levels (111–120).

## [1.10.0]

#### New Features

- Added 10 new game levels (101–110).

## [1.9.0]

#### New Features

- Added 10 new game levels (91–100).

## [1.8.0]

#### New Features

- Added support for fractional level IDs (0.1, 0.2).
- Renamed classic level 0 to 0.1.
- Added new level 0.2.

#### Improvements

- Database migration to support new level ID format.
- Existing users' progress is preserved automatically.

## [1.7.0]

#### New Features

- Added 10 new game levels (81–90).

## [1.6.0]

#### New Features

- Added 10 new game levels (71–80).

#### Enhancements

- Changed "no cell" symbol to "x" in level data for better readability.
- Added `upgrader` package for app updates.

## [1.5.0]

#### New Features

- Added 10 new game levels (61–70).

## [1.4.0]

#### New Features

- Added 10 new game levels (51–60).

#### Bug Fixes

- Improved detection and cleanup of corrupted game saves for affected levels.
- Enhanced rendering performance on Android devices.
- Improved touch responsiveness and tap detection.

## [1.3.8]

#### Bug Fixes

- Fixed critical issue in release mode where levels would not respond to taps after navigation
- Fixed issue where level screen required swipe/extra tap to become interactive
- Resolved provider state management issue causing frozen game board
- Fixed navigation state handling to prevent interaction blocking

#### Improvements

- Improved provider lifecycle management with keepAlive for better state persistence
- Enhanced navigation reliability between levels
- Optimized game state updates for smoother transitions

## [1.3.7]

#### Bug Fixes

- Resolved minor issues with restoring game state when returning to previously opened levels

#### Improvements

- Further refined database initialization to be more robust across app updates
- Small navigation and UI responsiveness tweaks for a smoother gameplay experience

## [1.3.6]

#### Improvements

- Improved and optimized work with the database for saving

## [1.3.5]

#### Bug Fixes

- Fixed critical issue where some levels failed to load for certain users after updates
- Added automatic recovery from corrupted saved game states
- Improved error handling during level loading with automatic fallback to fresh state

#### Improvements

- Added custom animated loading indicator with jumping pegs for better visual feedback
- Database now automatically cleans corrupted saved games while preserving completed levels progress
- Enhanced data migration reliability across app updates

## [1.3.4]

#### Bug Fixes

- Fixed issue when rapidly tapping multiple levels before loading completes

## [1.3.3]

#### Bug Fixes

- Fixed slow level loading on physical devices after completing a level
- Improved database operations handling to prevent race conditions

#### Improvements

- Enhanced game state saving reliability
- Optimized async operations for better performance on real devices
- Database queries now execute in parallel for faster level initialization
- Prevented duplicate navigation when rapidly selecting levels

## [1.3.2]

#### Bug Fixes

- Two levels have been fixed

#### Improvements

- Updated `levels_uniqueness_test` test
- Added `.github/workflows/dart.yml` file for CI

## [1.3.1]

#### Bug Fixes

- Fixed the completed level indicator error

#### Improvements

- Updated package dependencies

## [1.3.0]

#### New Features
- Added 10 new game levels (Levels 41–50).

#### Improvements
- Removed level unlock restrictions; all levels are now accessible

## [1.2.2]

#### New Features
- German language support (de_DE) added throughout the app

## [1.2.1]

#### New Features
- French language support (fr_FR) added throughout the app

## [1.2.0]

#### New Features

- Added 10 new game levels (Levels 31–40).

## [1.1.2]

#### New Features
- Italian language support (it_IT) added throughout the app

## [1.1.0]

#### New Features

- Added 10 new game levels (Levels 21–30).

#### Improvements

- Increased tutorial dialog size for better visibility and usability.

## [1.0.2]

#### New Features
- Spanish language support (es_ES) added throughout the app

## [1.0.1]

#### New Features
- Added the ability to evaluate the game.

## [1.0.0]

- Initial release of **Pegma**.
