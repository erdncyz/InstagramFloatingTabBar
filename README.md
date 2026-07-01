# InstagramFloatingTabBar

An Instagram-style **floating tab bar** for SwiftUI. It renders your tabs inside a
capsule that floats above your content and can automatically shrink into a
compact, icon-only pill as the user scrolls.

The component is fully generic and framework-agnostic — tabs, colors and icons
are all injected by you, so there are **no asset-catalog or design-system
dependencies**.

## Features

- 🫧 Floating capsule tab bar with a modern look
- 📜 Optional *minimize-on-scroll* behaviour (iOS 18+)
- 🧊 Automatic Liquid Glass background on iOS 26+, `.ultraThinMaterial` fallback
- 🎨 Fully themeable via `FloatingTabBarStyle`
- 🖼️ Works with SF Symbols or your own `Image` assets
- 🧩 Generic over any `Hashable` tab identifier
- ✅ Zero third-party dependencies

## Requirements

- iOS 16.0+
- Swift 5.9+

> The minimize-on-scroll modifier requires iOS 18+ and the Liquid Glass
> background requires iOS 26+; both degrade gracefully on older versions.

## Installation

### Swift Package Manager

Add the package in Xcode via **File → Add Package Dependencies…** using this
repository's URL, or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/erdncyz/InstagramFloatingTabBar.git", from: "1.0.0")
]
```

Then add `"InstagramFloatingTabBar"` to your target's dependencies.

## Usage

```swift
import SwiftUI
import InstagramFloatingTabBar

enum Tab: Hashable { case home, search, reels, profile }

struct ContentView: View {
    @State private var selection: Tab = .home
    @StateObject private var scrollState = TabBarScrollState()

    private let tabs: [FloatingTabItem<Tab>] = [
        FloatingTabItem(id: .home,    title: "Home",    systemImage: "house",           selectedSystemImage: "house.fill"),
        FloatingTabItem(id: .search,  title: "Search",  systemImage: "magnifyingglass"),
        FloatingTabItem(id: .reels,   title: "Reels",   systemImage: "play.rectangle",  selectedSystemImage: "play.rectangle.fill"),
        FloatingTabItem(id: .profile, title: "Profile", systemImage: "person",          selectedSystemImage: "person.fill")
    ]

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                // your content
            }
            .minimizesTabBar(scrollState) // shrinks the bar while scrolling (iOS 18+)

            FloatingTabBar(selection: $selection, tabs: tabs, scrollState: scrollState)
        }
    }
}
```

### Using your own image assets

```swift
FloatingTabItem(
    id: Tab.home,
    title: "Home",
    icon: Image("HomeIcon"),
    selectedIcon: Image("HomeIconFilled")
)
```

Icons are rendered in template mode and tinted with the style's
`selectedColor` / `unselectedColor`.

## Theming

Pass a `FloatingTabBarStyle` to customise colors, fonts, icon size and the
background treatment:

```swift
let style = FloatingTabBarStyle(
    selectedColor: .white,
    unselectedColor: .gray,
    iconSize: 28,
    titleFont: .system(size: 11, weight: .medium),
    usesLiquidGlassWhenAvailable: true
)

FloatingTabBar(selection: $selection, tabs: tabs, scrollState: scrollState, style: style)
```

## Minimize-on-scroll

`TabBarScrollState` drives the compact layout. Share a single instance between
the bar and your scrollable content:

```swift
@StateObject private var scrollState = TabBarScrollState(
    expandThreshold: 4,   // scroll offset below which the bar re-expands
    collapseThreshold: 24 // scroll offset above which the bar collapses
)
```

Attach `.minimizesTabBar(scrollState)` to the `ScrollView` (or `List`) and pass
the same `scrollState` to the `FloatingTabBar`. If you don't need this
behaviour, simply omit the `scrollState` argument.

## API Overview

| Type | Purpose |
| --- | --- |
| `FloatingTabBar` | The floating capsule tab bar view. |
| `FloatingTabItem` | Describes a single tab (id, title, icons). |
| `FloatingTabBarStyle` | Visual configuration (colors, fonts, background). |
| `TabBarScrollState` | Observable state powering minimize-on-scroll. |
| `View.minimizesTabBar(_:)` | Modifier that feeds scroll offset into the state. |

## License

Released under the MIT License. See [LICENSE](LICENSE).
