//
//  FloatingTabBar.swift
//  InstagramFloatingTabBar
//

import SwiftUI

/// An Instagram-style floating tab bar that renders a capsule of tab buttons and
/// can automatically shrink into a compact, icon-only form while the user scrolls.
///
/// The view is fully generic and free of any app-specific dependency: tabs,
/// colors and icons are all injected by the caller.
///
/// ```swift
/// enum Tab: Hashable { case home, search, profile }
///
/// struct ContentView: View {
///     @State private var selection: Tab = .home
///     @StateObject private var scrollState = TabBarScrollState()
///
///     private let tabs = [
///         FloatingTabItem(id: Tab.home, title: "Home", systemImage: "house"),
///         FloatingTabItem(id: Tab.search, title: "Search", systemImage: "magnifyingglass"),
///         FloatingTabItem(id: Tab.profile, title: "Profile", systemImage: "person")
///     ]
///
///     var body: some View {
///         ZStack(alignment: .bottom) {
///             ScrollView { /* content */ }
///                 .minimizesTabBar(scrollState)
///
///             FloatingTabBar(selection: $selection, tabs: tabs, scrollState: scrollState)
///         }
///     }
/// }
/// ```
public struct FloatingTabBar<ID: Hashable>: View {

    @Binding private var selection: ID
    private let tabs: [FloatingTabItem<ID>]
    private let style: FloatingTabBarStyle

    @ObservedObject private var scrollState: TabBarScrollState

    /// Creates a floating tab bar.
    /// - Parameters:
    ///   - selection: A binding to the currently selected tab's identifier.
    ///   - tabs: The tabs to display, in order.
    ///   - scrollState: State object driving the compact-on-scroll behaviour.
    ///     Pass the same instance to ``SwiftUI/View/minimizesTabBar(_:)``.
    ///     Defaults to a fresh, non-collapsing instance.
    ///   - style: Visual configuration. Defaults to ``FloatingTabBarStyle/default``.
    public init(
        selection: Binding<ID>,
        tabs: [FloatingTabItem<ID>],
        scrollState: TabBarScrollState = TabBarScrollState(),
        style: FloatingTabBarStyle = .default
    ) {
        self._selection = selection
        self.tabs = tabs
        self.scrollState = scrollState
        self.style = style
    }

    private var isCompact: Bool { scrollState.isCompact }

    private var isPad: Bool { UIDevice.current.userInterfaceIdiom == .pad }

    private var iconSize: CGFloat { isPad ? style.iconSize + 4 : style.iconSize }

    private var expandedMaxWidth: CGFloat? { isPad ? 440 : nil }

    public var body: some View {
        HStack(spacing: isCompact ? (isPad ? 18 : 10) : 0) {
            ForEach(tabs) { tab in
                tabButton(tab)
            }
        }
        .padding(.horizontal, isCompact ? (isPad ? 14 : 10) : 6)
        .padding(.vertical, isCompact ? (isPad ? 8 : 6) : 8)
        .background(barBackground)
        .frame(maxWidth: expandedMaxWidth)
        .padding(.horizontal, 16)
        .animation(.spring(response: 0.32, dampingFraction: 0.9), value: isCompact)
        .animation(.easeInOut(duration: 0.25), value: tabs.count)
    }

    private func tabButton(_ tab: FloatingTabItem<ID>) -> some View {
        let isSelected = selection == tab.id

        return Button {
            guard selection != tab.id else { return }
            withAnimation(.easeInOut(duration: 0.2)) {
                selection = tab.id
            }
        } label: {
            VStack(spacing: 4) {
                (isSelected ? tab.selectedIcon : tab.icon)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: iconSize, height: iconSize)
                    .foregroundStyle(isSelected ? style.selectedColor : style.unselectedColor)

                if !isCompact {
                    Text(tab.title)
                        .font(style.titleFont)
                        .fontWeight(isSelected ? .semibold : .medium)
                        .foregroundStyle(isSelected ? style.selectedColor : style.unselectedColor)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                        .multilineTextAlignment(.center)
                        .transition(.opacity)
                }
            }
            .frame(maxWidth: isCompact ? nil : .infinity)
            .padding(.vertical, isCompact ? (isPad ? 10 : 8) : 6)
            .padding(.horizontal, isCompact ? (isPad ? 10 : 8) : 4)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var barBackground: some View {
        if #available(iOS 26.0, *), style.usesLiquidGlassWhenAvailable {
            Capsule()
                .fill(Color.clear)
                .glassEffect(.regular, in: Capsule())
        } else {
            Capsule()
                .fill(.ultraThinMaterial)
                .overlay(
                    Capsule()
                        .strokeBorder(style.borderColor, lineWidth: style.borderWidth)
                )
                .shadow(color: style.shadowColor, radius: style.shadowRadius, x: 0, y: 6)
        }
    }
}

#if DEBUG
private enum PreviewTab: Hashable { case home, search, reels, profile }

#Preview {
    struct Demo: View {
        @State private var selection: PreviewTab = .home
        @StateObject private var scrollState = TabBarScrollState()

        private let tabs: [FloatingTabItem<PreviewTab>] = [
            FloatingTabItem(id: .home, title: "Home", systemImage: "house", selectedSystemImage: "house.fill"),
            FloatingTabItem(id: .search, title: "Search", systemImage: "magnifyingglass"),
            FloatingTabItem(id: .reels, title: "Reels", systemImage: "play.rectangle", selectedSystemImage: "play.rectangle.fill"),
            FloatingTabItem(id: .profile, title: "Profile", systemImage: "person", selectedSystemImage: "person.fill")
        ]

        var body: some View {
            ZStack(alignment: .bottom) {
                Color.black.ignoresSafeArea()

                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(0..<40, id: \.self) { index in
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.08))
                                .frame(height: 120)
                                .overlay(
                                    Text("Row \(index)")
                                        .foregroundStyle(.white.opacity(0.6))
                                )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 120)
                }
                .minimizesTabBar(scrollState)

                FloatingTabBar(selection: $selection, tabs: tabs, scrollState: scrollState)
            }
            .preferredColorScheme(.dark)
        }
    }
    return Demo()
}
#endif
