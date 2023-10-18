// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AddView",
	defaultLocalization: "ru",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "AddView",
            targets: ["AddView"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/UserDefaultsStandard/UserDefaultsStandard", branch: "master"),
        .package(url: "https://github.com/AppSentry/AppSentry", branch: "main"),
        .package(url: "https://github.com/AlertService/AlertService", branch: "master"),
        .package(url: "https://github.com/Architecture-org/Architecture", branch: "main"),
        .package(url: "https://github.com/Firebase-com/FirestoreFirebase", branch: "master"),
        .package(url: "https://github.com/AppFlyerSDK/AppFlyerSDK", branch: "master"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.1")),
        .package(url: "https://github.com/URLsOpen/OpenURL", branch: "master"),
        .package(url: "https://github.com/Juanpe/SkeletonView.git", from: "1.7.0"),
        .package(url: "https://github.com/livechat/chat-window-ios", branch: "master"),
        .package(url: "https://github.com/ashleymills/Reachability.swift.git", branch: "master"),
		.package(url: "https://github.com/amplitude/Amplitude-iOS", .upToNextMajor(from: "8.17.1")),
    ],
    targets: [
        .target(
            name: "AddView",
            dependencies: [
				.product(name: "Amplitude", package: "Amplitude-iOS"),
                .product(name: "Reachability", package: "Reachability.swift"),
                .product(name: "LiveChat", package: "chat-window-ios"),
                .product(name: "SentryApp", package: "AppSentry"),
                .product(name: "UserDefaultsStandard", package: "UserDefaultsStandard"),
                .product(name: "AlertService", package: "AlertService"),
                .product(name: "OpenURL", package: "OpenURL"),
                .product(name: "SnapKit", package: "SnapKit"),
                .product(name: "Architecture", package: "Architecture"),
                .product(name: "FirestoreFirebase", package: "FirestoreFirebase"),
                .product(name: "AppFlyerSDK", package: "AppFlyerSDK"),
                .product(name: "SkeletonView", package: "SkeletonView"),
            ],
            resources: [.process("Resources")]
        ),
    ]
)
