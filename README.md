# Vaquita Watch App

An interactive WatchOS application to raise awareness about the critically endangered vaquita porpoise, with fewer than 10 individuals remaining in the wild.

## Features

- Interactive vaquita avatar that you can customize and adopt on your Apple Watch
- Educational content about vaquitas and their conservation status
- Engaging animations and visual effects
- Virtual adoption system to support conservation efforts

## Project Structure

- Located within the `VaquitaWatch/` directory.
- SwiftUI-based interface
- MVVM architecture (`Models/`, `Views/`, `ViewModels/` directories)
- Uses environment objects for state management
- Assets managed in `VaquitaWatch/VaquitaWatch/Assets.xcassets/`

## Getting Started

1. Clone this repository
2. Open the `VaquitaWatch.xcodeproj` file in Xcode 14 or later.
3. Build and run on an Apple Watch device or simulator (check project settings for minimum watchOS version).

## Contributing

Contributions to improve the app are welcome. Please feel free to submit a Pull Request.

## Screenshots

(Screenshots will be added as the app development progresses)

## Adding Custom Vaquita Characters

To add your custom vaquita character designs to the app:

1.  Navigate to the Assets catalog: `VaquitaWatch/VaquitaWatch/Assets.xcassets/`
2.  Create a new **Image Set** inside the `Vaquitas` group (create the group if it doesn't exist). Name the image set appropriately, e.g., `vaquita_yourname.imageset`.
3.  Place your character image (preferably in **SVG** format) inside the newly created `.imageset` directory.
4.  Ensure a `Contents.json` file exists within the `.imageset` directory. This file tells Xcode how to handle the image. It should look similar to this, referencing your SVG file:
    ```json
    {
      "images" : [
        {
          "filename" : "your_vaquita_image.svg",
          "idiom" : "universal"
        }
      ],
      "info" : {
        "author" : "xcode",
        "version" : 1
      },
      "properties" : {
        // Important for SVG scaling!
        "preserves-vector-representation" : true
      }
    }
    ```
5.  Repeat for accessories in the `Accessories` group within the Assets catalog, following the same `.imageset` structure.

Using SVGs and the `.imageset` structure ensures your characters and accessories scale perfectly on different Apple Watch screen sizes. The `VaquitaImageView` (or relevant view) should load these assets by their image set name.

## License

This project is intended for educational purposes. 