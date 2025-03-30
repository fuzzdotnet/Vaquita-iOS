# Vaquita iOS App

An interactive iOS application to raise awareness about the critically endangered vaquita porpoise, with fewer than 10 individuals remaining in the wild.

## Features

- Interactive vaquita avatar that you can customize and adopt
- Educational content about vaquitas and their conservation status
- Engaging animations and visual effects
- Virtual adoption system to support conservation efforts

## Project Structure

- SwiftUI-based interface
- MVVM architecture
- Uses environment objects for state management

## Getting Started

1. Clone this repository
2. Open the project in Xcode 14 or later
3. Build and run on a device or simulator running iOS 15.0+

## Contributing

Contributions to improve the app are welcome. Please feel free to submit a Pull Request.

## Screenshots

(Screenshots will be added as the app development progresses)

## Adding Custom Vaquita Characters

To add your custom vaquita character designs to the app:

1. Place your character images in the appropriate directories within Assets.xcassets:

   - Create a directory structure: `Assets.xcassets/Vaquitas/`
   - Add your vaquita character files with these naming conventions:
     - Base vaquita: `vaquita_classic.svg` (48px base size)
     - Explorer variant: `vaquita_explorer.svg` (48px base size)
     - Night Glow variant: `vaquita_night_glow.svg` (48px base size)
     - Coral Reef variant: `vaquita_coral_reef.svg` (48px base size)
     - Golden Sunset variant: `vaquita_golden_sunset.svg` (48px base size)

2. Important: Use SVG format for all character images
   - SVGs are vector-based and will scale perfectly to any size
   - The base size of 48px is used as a reference, but the SVG will scale infinitely
   - No need to provide @2x or @3x versions - one SVG file is sufficient
   - iOS 13+ has native SVG support, so they'll render perfectly

3. For accessories, create a similar structure:
   - Create a directory: `Assets.xcassets/Accessories/`
   - Add accessories with naming convention: `bubbles_accessory.svg`, `heart_headband_accessory.svg`, etc.
   - Use SVG format for all accessories as well

The `VaquitaImageView` will automatically display your vector-based images at any size while maintaining perfect quality. If images are missing, it falls back to a placeholder.

## License

This project is intended for educational purposes. 