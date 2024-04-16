// swift-tools-version: 5.9
import PackageDescription

let package = Package(
  name: "PackageName",
  dependencies: [
    .package(url: "https://github.com/sindresorhus/Defaults", from: "1.0.0"),
    .package(url: "https://github.com/orchetect/SettingsAccess", from: "1.4.0"),
    .package(url: "https://github.com/sparkle-project/Sparkle", from: "2.6.0"),
  ]
)
