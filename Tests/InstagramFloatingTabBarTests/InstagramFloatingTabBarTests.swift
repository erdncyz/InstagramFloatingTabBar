import XCTest
import SwiftUI
@testable import InstagramFloatingTabBar

final class TabBarScrollStateTests: XCTestCase {

    func testCollapsesAfterPassingCollapseThreshold() {
        let state = TabBarScrollState(expandThreshold: 4, collapseThreshold: 24)
        XCTAssertFalse(state.isCompact)

        state.update(offset: 10)
        XCTAssertFalse(state.isCompact, "Should not collapse before the collapse threshold")

        state.update(offset: 30)
        XCTAssertTrue(state.isCompact, "Should collapse once past the collapse threshold")
    }

    func testExpandsAfterDroppingBelowExpandThreshold() {
        let state = TabBarScrollState(expandThreshold: 4, collapseThreshold: 24)
        state.update(offset: 30)
        XCTAssertTrue(state.isCompact)

        state.update(offset: 5)
        XCTAssertTrue(state.isCompact, "Should stay compact until below the expand threshold")

        state.update(offset: 2)
        XCTAssertFalse(state.isCompact, "Should expand once below the expand threshold")
    }
}

final class FloatingTabItemTests: XCTestCase {

    func testSelectedIconDefaultsToIcon() {
        let item = FloatingTabItem(id: 0, title: "Home", icon: Image(systemName: "house"))
        XCTAssertEqual(item.id, 0)
        XCTAssertEqual(item.title, "Home")
    }

    func testSystemImageInitialiser() {
        let item = FloatingTabItem(
            id: "search",
            title: "Search",
            systemImage: "magnifyingglass"
        )
        XCTAssertEqual(item.id, "search")
        XCTAssertEqual(item.title, "Search")
    }
}
