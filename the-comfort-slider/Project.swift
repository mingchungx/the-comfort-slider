import ProjectDescription

let project = Project(
    name: "the-comfort-slider",
    targets: [
        .target(
            name: "the-comfort-slider",
            destinations: .iOS,
            product: .app,
            bundleId: "dev.tuist.the-comfort-slider",
            deploymentTargets: .iOS("26.0"),
            infoPlist: .extendingDefault(
                with: [
                    "CFBundleDisplayName": "The Comfort Slider",
                    "UILaunchStoryboardName": "LaunchScreen",
                ]
            ),
            buildableFolders: [
                "the-comfort-slider/Sources",
                "the-comfort-slider/Resources",
            ],
            dependencies: [
                .external(name: "Pow"),
            ]
        ),
        .target(
            name: "the-comfort-sliderTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "dev.tuist.the-comfort-sliderTests",
            deploymentTargets: .iOS("26.0"),
            infoPlist: .default,
            buildableFolders: [
                "the-comfort-slider/Tests"
            ],
            dependencies: [.target(name: "the-comfort-slider")]
        ),
    ]
)
