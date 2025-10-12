# Cut to the Coffee - Project Structure

## 📁 Folder Organization

### **App/**
Main application entry point
- `Cut_to_the_CoffeeApp.swift` - App lifecycle and configuration
- App delegates and initialization code

### **FE/** (Frontend)
All user interface related code

#### **FE/pages/**
Screen-level views (full pages/screens)
- `ContentView.swift` - Main content view
- Example: `HomeView.swift`, `ProfileView.swift`, `SettingsView.swift`

#### **FE/components/**
Reusable UI components
- Example: `CustomButton.swift`, `LoadingSpinner.swift`, `CardView.swift`
- Small, reusable pieces that compose into pages

### **BE/** (Backend/Business Logic)
Application logic and data management

#### **BE/models/**
Data models and entities
- Example: `User.swift`, `Coffee.swift`, `Order.swift`
- Codable structs for API responses
- Core data entities

#### **BE/services/**
Business services and API clients
- Example: `APIService.swift`, `AuthService.swift`, `CoffeeService.swift`
- Network layer and API calls
- Third-party service integrations

#### **BE/controllers/**
ViewModels and business logic controllers
- Example: `HomeViewModel.swift`, `OrderViewModel.swift`
- State management
- Business logic that connects services to views

### **Utils/**
Utility functions and helpers
- Helper functions
- Constants
- Generic utilities
- Example: `DateFormatter+Extensions.swift`, `Constants.swift`

### **Config/**
Configuration files
- Environment configurations
- API endpoints
- Feature flags
- App configuration settings
- Example: `Environment.swift`, `AppConfig.swift`

### **Assets.xcassets/**
Image and color assets managed by Xcode

---

## 🎯 Best Practices

1. **Pages vs Components**: Pages are full screens, components are reusable pieces
2. **Services**: Keep network and business services separate and testable
3. **Models**: Keep models simple, focused on data structure
4. **ViewModels**: Place in controllers/ - they handle business logic and state
5. **Extensions**: Organize by type being extended
6. **Naming**: Use descriptive names that indicate purpose

## 📝 File Naming Conventions

- **Views**: `*View.swift` (e.g., `HomeView.swift`)
- **ViewModels**: `*ViewModel.swift` (e.g., `HomeViewModel.swift`)
- **Models**: Descriptive noun (e.g., `User.swift`, `Coffee.swift`)
- **Services**: `*Service.swift` (e.g., `APIService.swift`)
- **Extensions**: `Type+Extension.swift` (e.g., `String+Extensions.swift`)

## 🔄 Typical Flow

```
User Input → Page (FE/pages) → ViewModel (BE/controllers) → Service (BE/services) → Model (BE/models)
```

---

**Note**: After restructuring, make sure to update your Xcode project file references to match the new folder locations.

