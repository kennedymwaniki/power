# Simple UI App

A Flutter application demonstrating basic UI components including text widgets, buttons, and network images.

## Features

- **Title Bar**: Custom app bar with the application name
- **Welcome Text**: A styled text widget displaying a welcome message
- **Interactive Button**: An elevated button that prints a message to the console when clicked
- **Network Image**: An image widget that loads and displays an image from the internet

## UI Components

### 1. AppBar

- Displays the app title "Simple UI App"
- Centered title with a themed background color

### 2. Text Widget

- Welcome message with custom styling
- Font size: 24px
- Bold font weight
- Deep purple color

### 3. ElevatedButton Widget

- Custom styled button with rounded corners
- Prints a message to the console when clicked
- Proper padding and hover effects

### 4. Image Widget

- Loads image from network (Picsum Photos API)
- Includes loading indicator while image loads
- Error handling with fallback UI
- Rounded corners with shadow effect

## Layout Structure

The app uses a centered column layout with:

- Proper spacing between widgets (30px gaps)
- Responsive padding
- Center alignment for all components
- Material Design 3 theming

## Running the App

To run this Flutter application:

1. Ensure Flutter SDK is installed
2. Navigate to the project directory
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to start the application

## Console Output

When the button is clicked, you'll see the following message in the console:

```
Button was clicked! Welcome to Flutter development!
```

## Requirements Met

✅ Title bar with app name  
✅ Centered column layout  
✅ Text widget with welcome message  
✅ ElevatedButton with console logging  
✅ Image widget loading from internet  
✅ Proper alignment and spacing  
✅ Well-structured layout
