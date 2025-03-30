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

To add your custom 48px vaquita character designs to the app:

1. Place your character images in the appropriate directories within Assets.xcassets:

   - Create a directory structure: `Assets.xcassets/Vaquitas/`
   - Add your vaquita character files with these naming conventions:
     - Base vaquita: `vaquita_classic.png` (48px)
     - Deep Blue variant: `vaquita_deep_blue.png` (48px)
     - Night Glow variant: `vaquita_night_glow.png` (48px)
     - Coral Reef variant: `vaquita_coral_reef.png` (48px)
     - Golden Sunset variant: `vaquita_golden_sunset.png` (48px)

2. For optimal display on different devices, provide the following sizes:
   - 1x: 48x48px (@1x scale)
   - 2x: 96x96px (@2x scale)
   - 3x: 144x144px (@3x scale)

3. Name the files with the appropriate scale identifier:
   - `vaquita_classic.png` (48px, @1x)
   - `vaquita_classic@2x.png` (96px, @2x)
   - `vaquita_classic@3x.png` (144px, @3x)

4. For accessories, create a similar structure:
   - Create a directory: `Assets.xcassets/Accessories/`
   - Add accessories with naming convention: `bubbles_accessory.png`, `heart_headband_accessory.png`, etc.
   - Follow the same scaling guidelines for @1x, @2x, and @3x versions

The `VaquitaImageView` will automatically display your custom images when they match the naming conventions outlined above. If images are missing, it falls back to a placeholder.

## License

This project is intended for educational purposes. 