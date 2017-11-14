![](https://user-images.githubusercontent.com/4069241/32064578-3986e37a-ba48-11e7-80a0-68c7f85df21b.png)

# What is CommandKit?
CommandKit is an easy, extensible API for building your own Command Line Tools in Swift! It takes the mess out of structuring your own Command Line Tool architecture and allows you to focus on what your CLI is actually going to do.

# Setting Up
First, you'll need to add **CommandKit** as a dependency to your project. You can do this in one of two ways: via Swift Package Manager which I recommend, or by copying the **CommandKit** source files into your project.

### The Swift Package Manager (SPM) Way
**1.  Add CommandKit as a dependency** to your project in the manifest file `Package.swift` like so:

``` swift
dependencies: [
        .package(url: "https://github.com/xnukernel/CommandKit",
                 .upToNextMajor(from: "0")),
    ],
```

**2.  Add your CommandKit dependency to your target(s)** in your manifest file `Package.swift`:

``` swift
targets: [
        .target(name: "YourProjectsNameHere",
        dependencies: ["CommandKit"]),
    ]
```

**3.  Update & download SPM dependencies** by running `swift package update` or `swift build` from Terminal to download and update your **CommandKit** dependency in your project.

**4.  Import the dependency in your source files** via: `import CommandKit`

Now you're all setup and ready to begin writing your first Command.
