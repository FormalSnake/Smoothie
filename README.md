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

Whenever you pause, play, skip or go back a handy little indicator appears that tells you what's playing and it's status.

You can also trigger it manually using `⌘+⇧+space`.

<div><video controls src="https://github.com/user-attachments/assets/a3fc1022-1dd7-4ef3-b218-a838274733da" muted="false"></video></div>

### Battery indicator

Whenever you charge, stop charging or have a low battery a handy little popup appears to tell you information about your battery.

You can also trigger it manually using `⌘+⇧+b`.

<div><video controls src="https://github.com/user-attachments/assets/85530e52-5313-4cfd-97d8-dcef0d149dc0" muted="false"></video></div>

### Audio source indicator

Whenever your audio device changes, a handy little popup appears telling you what audio source is being used. This is handy especially when audio isn't working or to see if your earbuds connected.

You can also trigger it manually using `⌘+⇧+a`.

<div><video controls src="https://github.com/user-attachments/assets/7c5a1fc3-52fe-43f7-a438-380a327124b3" muted="false"></video></div>

## Why smoothie?
Smoothie is free and open source, meaning that it is forever yours.
Also, because our codebase is easy and modular you can easily contribute and add custom components!

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
