# Smoothie

## Building

This project uses Tuist to manage the Xcode project. To start developing, you will need to [install it](https://docs.tuist.io/guide/introduction/installation.html). For a quick copy-and-paste, here it is: `brew install --cask tuist`.

Next, clone this repo, and run the following two commands:
```sh
tuist install	# Install dependencies
tuist generate	# Make .xcodeproj file
```

This should automatically open the Xcode project for you, and you’re good to go! All of the source code is inside `Apps/`, and you can ignore the auto-generated folder called `Derived` :D
