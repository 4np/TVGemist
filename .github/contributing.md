
# Guidelined for contributing

If you would like to contribute code to this project, make sure to read the requirements for contributing code below.

## Xcode Project

In order to contribute using `Xcode`, you first need to generate an Xcode project. Run the following command in the project root:

```bash
swift package generate-xcodeproj
```

_Note that the Xcode project is in `.gitignore` and thus will not (and should not) be comitted to git._

## Style Guide

The code in this project follows a coding style that is similar to [Ray Wanderlich's Swift style guide](https://github.com/raywenderlich/swift-style-guide). Make sure the code you write adheres to this styleguide's **preferred** way of writing Swift code. 

## Linting

_Before_ sending a pull request, lint your code using the **most recent** [SwiftLint](https://github.com/realm/SwiftLint) release:

```bash
$ swiftlint
...
Done linting! Found 0 violations, 0 serious in 34 files.
```

_Before sending a pull request, there should be **zero** violations._

## Testing

If your code contains testable logic, write a test for it.