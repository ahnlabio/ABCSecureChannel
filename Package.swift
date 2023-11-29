// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "ABCSecureChannel",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(name: "ABCSecureChannel", targets: ["ABCSecureChannel"]),
        .library(name: "ABCUtils", targets: ["ABCUtils"])
    ],
    dependencies: [
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", from: "1.8.0"),
    ],
    targets: [
        .target(
            name: "ABCSecureChannel",
            dependencies: [
                .product(name: "CryptoSwift", package: "CryptoSwift"),
                "ABCUtils"
            ],
            path: "ABCSecureChannel/Sources"
        ),
        .target(
            name: "ABCUtils",
            path: "ABCUtils/Sources"
        ),
        .testTarget(
            name: "ABCSecureChannelTests",
            dependencies: ["ABCSecureChannel"],
            path: "ABCSecureChannel/Tests"
        )
    ]
)
