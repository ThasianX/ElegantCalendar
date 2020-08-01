// swift-tools-version:5.1

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
        .package(url: "https://github.com/ThasianX/ElegantPages", from: "1.4.1")
    ],
    targets: [
        .target(
            name: "ElegantCalendar",
            dependencies: ["ElegantPages"])
    ]
)
