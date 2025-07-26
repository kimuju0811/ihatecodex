# WebtoonManager

A simple SwiftUI app skeleton for managing webtoons.

## Building
Create a new iOS App project in Xcode (iOS 17 or later) and replace the template's source files with the contents of the `WebtoonManager` folder. Then build the `WebtoonManagerApp` target.
Copy `WebtoonManager/Info.plist` into your project or make sure your own Info.plist includes `NSPhotoLibraryUsageDescription`, `NSPhotoLibraryAddUsageDescription`, and `NSAppTransportSecurity` with `NSAllowsArbitraryLoads` so the app can access the photo library and fetch web data. If you import this plist file, replace the default one referenced by your target's **Info.plist File** setting and remove any duplicate entry from *Copy Bundle Resources* to avoid build errors about multiple Info.plist files.

## Features
- Four tabs: Home, Search, Add Webtoon, Settings.
- Search results lead to a detail view with a progress bar for reading status.
- Basic data model for storing webtoon info including thumbnail URL.
- Automatic API updates can run while the app is open when enabled in Settings.
- Home page displays your own `AppLogo` image scaled to about 390pt width. Add any square asset named `AppLogo` and it will be resized automatically.
- App remembers the last selected tab and saved webtoons across launches.
- Edit or delete saved webtoons in the Search tab via swipe actions. Sorting options include rating, title or most recent update.
- Add multiple writers and genres, numeric episode fields and local image selection when creating or editing webtoons.
- Manage global writer, studio and genre lists under Settings → 카테고리 관리.
- Choose between light, dark, sepia, poster or pink themes in Settings; the selection applies immediately.
- Saved categories, writers and studios can be removed using the - button while editing the list.
- The first launch requests photo library permission and asks whether to allow
  network access for automatic updates.
