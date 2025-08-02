# Mobile Banking App

A comprehensive Flutter mobile banking application featuring a modern UI with login functionality and home dashboard.

## 🏦 Features

### Login Screen

- **Title Bar**: "SecureBank Mobile" app bar with modern styling
- **Welcome Message**: Styled container with welcome text and subtitle
- **Bank Image**: Network image widget displaying bank building
- **Login Form**: Column layout with username and password fields
- **Interactive Buttons**: Row layout with Login and Register buttons
- **Demo Button**: Interactive button that prints to console
- **User Experience**: Proper spacing, padding, and Material Design 3

### Home Screen

- **Welcome Container**: Personalized greeting with gradient background
- **Bank Image**: Professional bank building image from network
- **Interactive Demo**: Button that prints console messages
- **Balance Card**: Styled container showing account balance
- **Quick Actions**: Row of action buttons (Transfer, Pay Bills, Deposit, More)
- **Recent Transactions**: List of recent banking transactions
- **Bottom Navigation**: 5-tab navigation bar

## 🎨 UI Components

### ✅ **Title Bar**

- Custom AppBar with "SecureBank Mobile" title
- Consistent blue branding (#2E5BBA)
- Action buttons for notifications and logout

### ✅ **Welcome Message & Styled Container**

- Gradient background containers
- Proper padding and border radius
- Shadow effects for depth
- Responsive text styling

### ✅ **Interactive Buttons**

- ElevatedButton widgets with console logging
- Custom styling with rounded corners
- Different button types (Elevated, Outlined)
- Proper feedback with SnackBar messages

### ✅ **Image Widgets**

- Network images with loading states
- Error handling with fallback UI
- Professional bank-related imagery
- Proper aspect ratios and styling

### ✅ **Login Layout Design**

- Column widget for vertical arrangement
- TextField widgets with proper labels
- Row widget for side-by-side buttons
- Consistent spacing and padding
- Material Design input styling

## 🎯 Assignment Requirements Met

### Build a Simple User Interface ✅

- [x] Title bar with app name
- [x] Welcome message with Text widget
- [x] Styled Container with color, borderRadius, padding
- [x] Interactive ElevatedButton with console logging
- [x] Image widget loading from internet

### Design a Basic Login Layout ✅

- [x] Column widget for vertical arrangement
- [x] Two TextField widgets (username/password)
- [x] Row widget with login/register buttons
- [x] Proper padding and spacing
- [x] Clean, organized layout

### User Experience Considerations ✅

- [x] Proper widget alignment and spacing
- [x] Descriptive labels for text fields and buttons
- [x] User-friendly interface design
- [x] Material Design 3 theming
- [x] Loading states and error handling

## 🚀 Project Structure

```
mobile_banking_app/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── screens/
│   │   ├── login_screen.dart     # Login UI with form
│   │   └── home_screen.dart      # Dashboard with widgets
│   └── widgets/
│       ├── balance_card.dart     # Account balance display
│       ├── quick_actions.dart    # Action buttons
│       └── recent_transactions.dart # Transaction list
├── android/                      # Android configuration
├── pubspec.yaml                  # Dependencies
└── README.md                     # Documentation
```

## 💡 Console Output

The app prints various messages to the console when buttons are clicked:

```
Login Button Clicked!
Username: [entered username]
Password: [entered password]
Register Button Clicked!
Button Clicked! - Interactive Demo
Quick Action: Transfer clicked!
Transaction Amazon Purchase clicked!
```

## 🎨 Design Features

- **Modern Material Design 3** theming
- **Gradient backgrounds** for visual appeal
- **Consistent color scheme** with blue primary (#2E5BBA)
- **Proper spacing** with 16-24px margins
- **Shadow effects** for depth and layering
- **Responsive layout** that works on different screen sizes
- **Loading states** for network images
- **Error handling** with fallback UI

## 🔧 Running the App

1. Ensure Flutter SDK is installed
2. Navigate to the project directory:
   ```bash
   cd mobile_banking_app
   ```
3. Get dependencies:
   ```bash
   flutter pub get
   ```
4. Run the application:
   ```bash
   flutter run
   ```

## 📱 Navigation

- App starts on **Login Screen** (`/login`)
- Successful login navigates to **Home Screen** (`/home`)
- Logout button returns to **Login Screen**
- Bottom navigation ready for additional screens

## 🔐 Security Note

This is a UI demonstration app. In a real banking application, proper authentication, encryption, and security measures would be implemented.
