//
//  TabBarScrollState.swift
//  InstagramFloatingTabBar
//

import SwiftUI
import Combine

/// Observable state driving the "minimize on scroll" behaviour of a ``FloatingTabBar``.
///
/// Create one instance, keep it alive in your view hierarchy (for example as a
/// `@StateObject`), pass it to the tab bar and attach
/// ``SwiftUI/View/minimizesTabBar(_:)`` to your scrollable content.
public final class TabBarScrollState: ObservableObject {

    /// Whether the bar is currently in its compact (icon-only) layout.
    @Published public private(set) var isCompact: Bool = false

    /// Offset (in points) required to expand the bar again once compact.
    private let expandThreshold: CGFloat

    /// Offset (in points) required to collapse the bar while expanded.
    private let collapseThreshold: CGFloat

    /// Creates a scroll state.
    /// - Parameters:
    ///   - expandThreshold: Scroll offset below which the bar expands. Default `4`.
    ///   - collapseThreshold: Scroll offset above which the bar collapses. Default `24`.
    public init(expandThreshold: CGFloat = 4, collapseThreshold: CGFloat = 24) {
        self.expandThreshold = expandThreshold
        self.collapseThreshold = collapseThreshold
    }

    /// Feeds a new scroll offset into the state machine.
    public func update(offset: CGFloat) {
        let shouldCompact = isCompact ? offset > expandThreshold : offset > collapseThreshold
        guard shouldCompact != isCompact else { return }
        isCompact = shouldCompact
    }
}

public extension View {

    /// Minimises the associated ``FloatingTabBar`` as the user scrolls.
    ///
    /// Attach this to your scrollable content and share the same
    /// ``TabBarScrollState`` instance with the tab bar. Requires iOS 18+;
    /// on earlier versions it is a no-op.
    @ViewBuilder
    func minimizesTabBar(_ state: TabBarScrollState) -> some View {
        if #available(iOS 18.0, *) {
            self.onScrollGeometryChange(for: CGFloat.self) { geometry in
                geometry.contentOffset.y + geometry.contentInsets.top
            } action: { _, newValue in
                state.update(offset: newValue)
            }
        } else {
            self
        }
    }
}
