<div align="center">
  <img width="225" height="225" src="https://github.com/FormalSnake/Smoothie/blob/main/App/Resources/Assets.xcassets/AppIcon.appiconset/Smoothie-1024.png" alt="Logo">
  <h1><b>Smoothie</b></h1>
  <p>A smooth and minimal dynamic island for the notch.<br>
  <a href="https://nightly.link/FormalSnake/Smoothie/workflows/build-smoothie/main/Smoothie.dmg.zip?h=cd34864d072cb859bbfa319e3ae76484bc67a692">Download for macOS</a><br>
  <i>~ Compatible with macOS 13 and later. ~</i></p>
</div>

Smoothie is a minimal dynamic island for the notch on MacOS, even compatible on non-notched devices!

> [!NOTE]
>
> Smoothie is looking for maintainers! Me and MrKai77 are busy with school and thus have no time.
>

<h6 align="center">
  <img src="https://github.com/user-attachments/assets/6685164d-43c8-47df-9c2d-2a6c5a79ff0a" alt="Smoothie Demo">
  <br /><br />
  <a href="https://discord.gg/nwRrjPSaTM">
    <img src="https://img.shields.io/badge/Discord-join%20us-7289DA?logo=discord&logoColor=white&style=for-the-badge&labelColor=23272A" />
  </a>
  <a href="https://github.com/FormalSnake/Smoothie/blob/main/LICENSE">
    <img src="https://img.shields.io/github/license/FormalSnake/Smoothie?label=License&color=5865F2&style=for-the-badge&labelColor=23272A" />
  </a>
  <a href="https://github.com/FormalSnake/Smoothie/stargazers">
    <img src="https://img.shields.io/github/stars/FormalSnake/Smoothie?label=Stars&color=57F287&style=for-the-badge&labelColor=23272A" />
  </a>
  <a href="https://github.com/FormalSnake/Smoothie/network/members">
    <img src="https://img.shields.io/github/forks/FormalSnake/Smoothie?label=Forks&color=ED4245&style=for-the-badge&labelColor=23272A" />
  </a>
  <a href="https://github.com/FormalSnake/Smoothie/issues">
    <img src="https://img.shields.io/github/issues/FormalSnake/Smoothie?label=Issues&color=FEE75C&style=for-the-badge&labelColor=23272A" />
  </a>
  <br />
</h6>

## Features

### Now playing

The Radial Menu allows you to manipulate windows using your mouse/trackpad. Hold down the trigger key and move your cursor in the desired direction to move and resize the window.

<div><video controls src="https://github.com/user-attachments/assets/658f7043-79a1-4690-83b6-a714fe6245c8" muted="false"></video></div>

### Battery indicator

The preview window enables you to see the resize action *before* committing to it.

<div><video controls src="https://github.com/user-attachments/assets/5ecb3ae8-f295-406f-b968-31e539f4a098" muted="false"></video></div>

### Audio source indicator

Loop allows you to assign any key in tandem with the trigger key to initiate a window manipulation action.

<div><video controls src="https://github.com/user-attachments/assets/d865329f-0533-4eeb-829d-9aa6159f454b" muted="false"></video></div>

## Building

This project uses Tuist to manage the Xcode project. To start developing, you will need to [install it](https://docs.tuist.io/guide/introduction/installation.html). For a quick copy-and-paste, here it is: 
```sh
brew install --cask tuist
```

Next, clone this repo, and run the following two commands:
```sh
tuist install	# Install dependencies
tuist generate	# Make .xcodeproj file
```

This should automatically open the Xcode project for you, and you’re good to go! All of the source code is inside `Apps/`, and you can ignore the auto-generated folder called `Derived` :D
