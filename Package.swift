// swift-tools-version:4.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BiMap",
    products: [
        .library(
            name: "BiMap",
            targets: ["BiMap"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "BiMap",
            dependencies: []),
        .testTarget(
            name: "BiMapTests",
            dependencies: ["BiMap"]),
    ]
)
