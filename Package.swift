import PackageDescription

let package = Package(
    name: "hello-perfect",
    dependencies: [
        .Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 2)
    ]
)

