//
//  FloatingTabBarStyle.swift
//  InstagramFloatingTabBar
//

import SwiftUI

/// Visual configuration for the ``FloatingTabBar``.
///
/// All colors are injected so the package does not depend on any external
/// design-system definitions. Tweak an instance and pass it to the tab bar,
/// or use ``FloatingTabBarStyle/default`` for sensible dark-mode defaults.
public struct FloatingTabBarStyle {

    /// Tint used for the icon / title of the selected tab.
    public var selectedColor: Color

    /// Tint used for the icon / title of unselected tabs.
    public var unselectedColor: Color

    /// Fill color of the capsule background (ignored when Liquid Glass is used).
    public var backgroundColor: Color

    /// Border color drawn around the capsule background.
    public var borderColor: Color

    /// Width of the capsule border.
    public var borderWidth: CGFloat

    /// Shadow color applied to the bar.
    public var shadowColor: Color

    /// Shadow blur radius.
    public var shadowRadius: CGFloat

    /// Size of the tab icons.
    public var iconSize: CGFloat

    /// Font used for tab titles.
    public var titleFont: Font

    /// When `true` and running on iOS 26+, the bar uses the system
    /// Liquid Glass effect instead of the material fill.
    public var usesLiquidGlassWhenAvailable: Bool

    /// Creates a style.
    public init(
        selectedColor: Color = Color(white: 0.85),
        unselectedColor: Color = Color(white: 0.5),
        backgroundColor: Color = .clear,
        borderColor: Color = Color(white: 0.96).opacity(0.14),
        borderWidth: CGFloat = 1,
        shadowColor: Color = .black.opacity(0.35),
        shadowRadius: CGFloat = 16,
        iconSize: CGFloat = 26,
        titleFont: Font = .system(size: 10, weight: .medium),
        usesLiquidGlassWhenAvailable: Bool = true
    ) {
        self.selectedColor = selectedColor
        self.unselectedColor = unselectedColor
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.shadowColor = shadowColor
        self.shadowRadius = shadowRadius
        self.iconSize = iconSize
        self.titleFont = titleFont
        self.usesLiquidGlassWhenAvailable = usesLiquidGlassWhenAvailable
    }

    /// A ready-to-use dark-mode style.
    public static let `default` = FloatingTabBarStyle()
}
