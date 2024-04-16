import ProjectDescription

let project = Project(
    name: "Smoothie",
    packages: [
        .remote(url: "https://github.com/MrKai77/DynamicNotchKit", requirement: .branch("main")),
        .remote(url: "https://github.com/rnine/SimplyCoreAudio", requirement: .branch("develop")),
        .remote(url: "https://github.com/sindresorhus/Defaults", requirement: .branch("main")),
        .remote(url: "https://github.com/sparkle-project/Sparkle", requirement: .branch("2.x")),
        .remote(url: "https://github.com/orchetect/SettingsAccess", requirement: .branch("main")),
        .remote(url: "https://github.com/sindresorhus/KeyboardShortcuts", requirement: .branch("main"))
    ],
    targets: [
        .target(
            name: "Smoothie",
            destinations: .macOS,
            product: .app,
            bundleId: "com.formalsnake.Smoothie",
            deploymentTargets: .macOS("13.0"),
            sources: ["App/Sources/**"],
            resources: ["App/Resources/**"],
            dependencies: [
                .package(product: "DynamicNotchKit", type: .runtime),
                .package(product: "SimplyCoreAudio", type: .runtime),
                .package(product: "Defaults", type: .runtime),
                .package(product: "Sparkle", type: .runtime),
                .package(product: "SettingsAccess", type: .runtime),
                .package(product: "KeyboardShortcuts", type: .runtime)
            ],
            settings: Settings.settings(
                base: [
                    "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
                    "CODE_SIGN_IDENTITY": "Apple Development",
                    "CODE_SIGN_STYLE": "Automatic",
                    "ENABLE_HARDENED_RUNTIME": true,
                    "PRODUCT_NAME": "Smoothie"
                ],
                configurations: [
                    .release(name: "Release")
                ]
            )
        ),
    ],
    additionalFiles: [
        .glob(pattern: "README.md")
    ]
)
