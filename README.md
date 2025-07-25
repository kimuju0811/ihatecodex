# WebtoonManager

A simple SwiftUI app skeleton for managing webtoons.

## Building
Create a new iOS App project in Xcode (iOS 17 or later) and replace the template's source files with the contents of the `WebtoonManager` folder. Then build the `WebtoonManagerApp` target.

## Features
- Four tabs: Home, Search, Add Webtoon, Settings.
- Search results lead to a detail view with a progress bar for reading status.
- Basic data model for storing webtoon info including thumbnail URL.
- Placeholder automatic API update toggle in Settings.
- Home page displays `AppLogo` image scaled to 390pt width. Add your own 2048x2048 image named `AppLogo` in Assets.xcassets.
- App remembers the last selected tab and saved webtoons across launches.
- Edit or delete saved webtoons in the Search tab via swipe actions. Sorting options include rating, title or most recent click.
- Add multiple writers and genres, numeric episode fields and local image selection when creating or editing webtoons.
- Manage global writer, studio and genre lists under Settings → 카테고리 관리.
- The first launch requests photo library permission and asks whether to allow
  network access for automatic updates.
