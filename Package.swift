// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "ElegantCalendar",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "ElegantCalendar",
            targets: ["ElegantCalendar"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ThasianX/ElegantPages", .branch("custom-width"))
    ],
    targets: [
        .target(
            name: "ElegantCalendar",
            dependencies: ["ElegantPages"])
    ]
)
