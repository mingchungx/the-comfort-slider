import ProjectDescription

let project = Project(
    name: "the-comfort-slider",
    targets: [
        .target(
            name: "the-comfort-slider",
            destinations: [.iPhone],
            product: .app,
            bundleId: "com.eclipsecard.thecomfortslider",
            deploymentTargets: .iOS("26.0"),
            infoPlist: .extendingDefault(
                with: [
                    "CFBundleDisplayName": "The Comfort Slider",
                    "CFBundleShortVersionString": "1.0",
                    "CFBundleVersion": "1",
                    "UILaunchStoryboardName": "LaunchScreen",
                    "ITSAppUsesNonExemptEncryption": false,
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
            destinations: [.iPhone],
            product: .unitTests,
            bundleId: "com.eclipsecard.thecomfortslider.tests",
            deploymentTargets: .iOS("26.0"),
            infoPlist: .default,
            buildableFolders: [
                "the-comfort-slider/Tests"
            ],
            dependencies: [.target(name: "the-comfort-slider")]
        ),
    ]
)
