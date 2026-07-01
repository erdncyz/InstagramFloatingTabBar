// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "InstagramFloatingTabBar",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "InstagramFloatingTabBar",
            targets: ["InstagramFloatingTabBar"]
        )
    ],
    targets: [
        .target(
            name: "InstagramFloatingTabBar"
        ),
        .testTarget(
            name: "InstagramFloatingTabBarTests",
            dependencies: ["InstagramFloatingTabBar"]
        )
    ]
)
