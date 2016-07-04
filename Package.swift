import PackageDescription

let package = Package(
    name: "LoginKit",
    dependencies: [
        .Package(url: "https://github.com/Alamofire/Alamofire.git", versions: Version(3, 2, 0)..<Version(4, 0, 0)),
        .Package(url: "https://github.com/kishikawakatsumi/KeychainAccess")
    ]
)
