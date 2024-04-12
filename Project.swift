import ProjectDescription

let project = Project(
    name: "Smoothie",
    packages: [
        .remote(url: "https://github.com/MrKai77/DynamicNotchKit", requirement: .branch("main")),
        .remote(url: "https://github.com/rnine/SimplyCoreAudio", requirement: .branch("develop")),
    ],
    targets: [
        .target(
            name: "Smoothie",
            destinations: .macOS,
            product: .app,
            bundleId: "com.formalsnake.Smoothie",
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .package(product: "DynamicNotchKit", type: .runtime),
                .package(product: "SimplyCoreAudio", type: .runtime),
            ]
        ),
    ]
)
