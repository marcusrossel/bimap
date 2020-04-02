// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "BiMap",
    
    products: [
        .library(
            name: "BiMap",
            targets: ["BiMap"]
        ),
    ],
    
    dependencies: [],
    
    targets: [
        .target(
            name: "BiMap",
            dependencies: []
        ),
        .testTarget(
            name: "BiMapTests",
            dependencies: ["BiMap"]
        ),
    ]
)
