# 4.0.0 (12/10/2019)

- Will now only send updates specifically to people that request them
- Fixed issue where accepting a trade of a lotus or getting a lotus from a mailbox outside of a zone with lotus would result in a timer being updated
- Fixed issue where broadcast/request were not working due to issues with time zones

# 3.1.0 (12/07/2019)

- Simplified how timers and versions are compared

## 3.0.2 (12/05/2019)

- Broadcasting/requesting bug fixes

## 3.0.1 (12/05/2019)

- Broadcasting and general bug fixes

## 3.0.0 (12/05/2019)

- Added code to notify user that an update is available
- Made it so addon must share major version with other copies that it is interacting with
- Added ability to request timers from party/guild members
- Added datestamp for when timers were updated. Syncing with others will now use whoever has the most recent datestamp for a timer

## 2.0.0 (12/04/2019)

- Re-wrote code be broken down into more concise groupings across multiple files
- Updated how timers are stored both internally and in the SavedVariables
- Implemented caching to speed up window calculation
- Addressed display, broadcasting, and saving bugs

## 1.0.0 (12/01/2019)

- Initial release of LotusWindow
