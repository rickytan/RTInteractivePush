// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "RTInteractivePush",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(name: "RTInteractivePush", targets: ["RTInteractivePush"])
    ],
    targets: [
        .target(
            name: "RTInteractivePush",
            path: "Classes",
            publicHeadersPath: ".",
            linkerSettings: [
                .linkedFramework("UIKit"),
                .linkedFramework("Foundation")
            ]
        ),
        .testTarget(
            name: "RTInteractivePushTests",
            dependencies: ["RTInteractivePush"]
        )
    ]
)
