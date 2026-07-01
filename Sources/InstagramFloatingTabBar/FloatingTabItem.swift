//
//  FloatingTabItem.swift
//  InstagramFloatingTabBar
//

import SwiftUI

/// A single item displayed in the ``FloatingTabBar``.
///
/// Each item carries a stable identifier, a title and the images used for its
/// selected / unselected states. Images are supplied by the caller so the
/// package stays free of any asset-catalog dependency.
public struct FloatingTabItem<ID: Hashable>: Identifiable {

    /// A stable, unique identifier for the tab.
    public let id: ID

    /// The title rendered under the icon (hidden while the bar is compact).
    public let title: String

    /// The image shown when the tab is **not** selected.
    public let icon: Image

    /// The image shown when the tab **is** selected.
    public let selectedIcon: Image

    /// Creates a tab item.
    /// - Parameters:
    ///   - id: A stable, unique identifier for the tab.
    ///   - title: The title rendered under the icon.
    ///   - icon: The image shown when the tab is not selected.
    ///   - selectedIcon: The image shown when the tab is selected. Defaults to `icon`.
    public init(
        id: ID,
        title: String,
        icon: Image,
        selectedIcon: Image? = nil
    ) {
        self.id = id
        self.title = title
        self.icon = icon
        self.selectedIcon = selectedIcon ?? icon
    }

    /// Convenience initialiser using SF Symbol names.
    /// - Parameters:
    ///   - id: A stable, unique identifier for the tab.
    ///   - title: The title rendered under the icon.
    ///   - systemImage: SF Symbol name used when the tab is not selected.
    ///   - selectedSystemImage: SF Symbol name used when selected. Defaults to `systemImage`.
    public init(
        id: ID,
        title: String,
        systemImage: String,
        selectedSystemImage: String? = nil
    ) {
        self.id = id
        self.title = title
        self.icon = Image(systemName: systemImage)
        self.selectedIcon = Image(systemName: selectedSystemImage ?? systemImage)
    }
}
