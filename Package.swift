// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LoginKit",
    dependencies: [
        .Package(url: "https://github.com/Alamofire/Alamofire.git", versions: Version(3, 2, 0)..<Version(4, 0, 0)),
        .Package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git")
    ]
)
