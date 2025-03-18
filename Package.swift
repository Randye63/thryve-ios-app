// Debug: Importing PackageDescription module
import PackageDescription

// Debug: Defining package for ThryveApp
let package = Package(
    name: "ThryveApp",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "ThryveApp", targets: ["ThryveApp"])
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: "10.0.0"))
    ],
    targets: [
        .target(
            name: "ThryveApp",
            dependencies: [
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseCore", package: "firebase-ios-sdk")
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "ThryveAppTests",
            dependencies: ["ThryveApp"]
        )
    ]
) 