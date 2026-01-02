# 📍 Nearby Places App

A modern iOS application built with **SwiftUI** that helps users discover nearby places using the Google Places API. Search for ATMs, restaurants, spas, pharmacies, and more with real-time location tracking.

![iOS](https://img.shields.io/badge/iOS-15.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-5.5+-orange.svg)
![SwiftUI](https://img.shields.io/badge/SwiftUI-3.0+-green.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)

---

## 📱 Features

### Core Functionality
- 🔍 **Real-time Search**: Search for any type of place near your location
- 📍 **Live Location Tracking**: Automatic location detection with reverse geocoding
- 🗺️ **Google Places Integration**: Powered by Google Places API for accurate results
- ⚡ **Instant Results**: Fast and responsive search with loading indicators
- 🎨 **Modern UI**: Clean, intuitive interface built with SwiftUI

### User Experience
- **Loading States**: Visual feedback while searching
- **Empty States**: Helpful messages when no results found
- **Location Display**: Shows city, state, and country
- **Search Debouncing**: Optimized to reduce unnecessary API calls
- **Beautiful Cards**: Places displayed in elegant card layout

### Technical Features
- **MVVM Architecture**: Clean separation of concerns
- **Reactive Programming**: SwiftUI's @Published properties
- **Error Handling**: Graceful handling of network and location errors
- **Battery Optimization**: Stops location updates after getting coordinates
- **Memory Management**: Proper use of weak references to prevent leaks

---

## 🚀 Getting Started

### Prerequisites
- **Xcode 13.0+**
- **iOS 15.0+**
- **Apple Developer Account** (for device testing)
- **Google Cloud Account** with Places API enabled

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/NearbyPlacesApp.git
   cd NearbyPlacesApp
   ```

2. **Get Google Places API Key**
   - Go to [Google Cloud Console](https://console.cloud.google.com/)
   - Create a new project or select existing one
   - Enable "Places API"
   - Create credentials (API Key)
   - Restrict the key to iOS apps for security

3. **Add API Key**
   - Open `PlacesAPIService.swift`
   - Replace the placeholder with your API key:
   ```swift
   private let apiKey = "YOUR_GOOGLE_PLACES_API_KEY_HERE"
   ```

4. **Configure Info.plist**
   Add location permission descriptions:
   ```xml
   <key>NSLocationWhenInUseUsageDescription</key>
   <string>We need your location to find nearby places</string>
   ```

5. **Build and Run**
   - Open `NearbyPlacesApp.xcodeproj` in Xcode
   - Select your target device or simulator
   - Press `Cmd + R` to build and run

---

## 🏗️ Project Architecture

### MVVM Pattern
```
┌─────────────────┐
│     View        │  ← ContentView.swift
│   (SwiftUI)     │     PlaceCardView
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   ViewModel     │  ← PlacesViewModel.swift
│  (ObservableObject)
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│     Model       │  ← Place.swift
│  (Data Structure)
└─────────────────┘
         │
         ▼
┌─────────────────┐
│    Service      │  ← PlacesAPIService.swift
│  (API Layer)    │     LocationManager.swift
└─────────────────┘
```

### File Structure
```
NearbyPlacesApp/
├── Models/
│   └── Place.swift                 # Data model for places
├── ViewModels/
│   └── PlacesViewModel.swift       # Business logic & state management
├── Services/
│   ├── PlacesAPIService.swift      # Google Places API integration
│   └── LocationManager.swift       # Location tracking & permissions
└── Views/
    └── ContentView.swift           # Main UI components
```

---

## 💻 Code Explanation

### 1. Place Model (`Place.swift`)
Represents a single place with all its properties:

```swift
struct Place: Identifiable {
    let id = UUID()              // Unique identifier
    let name: String             // Place name
    let address: String          // Full address
    let rating: Double?          // Google rating (1-5)
    let isOpen: Bool?            // Currently open/closed
    let distance: Double?        // Distance in km
}
```

**Why it matters:**
- `Identifiable` protocol enables SwiftUI to track items in lists
- Optional properties handle missing data gracefully
- UUID ensures each place is uniquely identifiable

---

### 2. PlacesViewModel (`PlacesViewModel.swift`)
Manages the app's business logic and state:

```swift
final class PlacesViewModel: ObservableObject {
    @Published var places: [Place] = []      // Updates UI automatically
    @Published var isLoading: Bool = false   // Shows/hides loading indicator
    
    func search(text: String, location: CLLocation?) {
        // Validates input
        // Shows loading state
        // Calls API service
        // Updates UI with results
    }
}
```

**Key Features:**
- **@Published**: Automatically updates UI when values change
- **Validation**: Checks for empty strings and valid location
- **Main Thread Safety**: All UI updates happen on main thread
- **Weak References**: Prevents memory leaks with `[weak self]`

---

### 3. PlacesAPIService (`PlacesAPIService.swift`)
Handles all communication with Google Places API:

```swift
func searchPlaces(
    query: String,
    location: CLLocation,
    completion: @escaping ([Place]) -> Void
) {
    // 1. Build API URL with query and coordinates
    // 2. Make network request
    // 3. Parse JSON response
    // 4. Convert to Place objects
    // 5. Return results via completion handler
}
```

**API Request Structure:**
```
https://maps.googleapis.com/maps/api/place/textsearch/json
  ?query=restaurant+near+me
  &location=37.7749,-122.4194
  &radius=5000
  &key=YOUR_API_KEY
```

**Response Parsing:**
- Extracts place name and address
- Handles missing data with optional chaining
- Returns empty array on errors (graceful degradation)

---

### 4. LocationManager (`LocationManager.swift`)
Manages device location and permissions:

```swift
final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var location: CLLocation?          // User's coordinates
    @Published var locationName: String           // Human-readable address
    @Published var permissionStatus: CLAuthorizationStatus
    @Published var isLoadingLocation: Bool
    
    // Handles permission changes
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager)
    
    // Receives location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    
    // Converts coordinates to address
    private func reverseGeocode(location: CLLocation)
}
```

**Permission Flow:**
1. Check current authorization status
2. Request permission if not determined
3. Start location updates when authorized
4. Stop updates after getting location (saves battery)

**Reverse Geocoding:**
- Converts coordinates → readable address
- Example: `(37.7749, -122.4194)` → `San Francisco, CA, USA`

---

### 5. ContentView (`ContentView.swift`)
Main user interface built with SwiftUI:

```swift
struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var viewModel = PlacesViewModel()
    @State private var searchText = ""
    
    var body: some View {
        // Location display
        // Search field
        // Loading indicator
        // Results list
    }
}
```

**UI Components:**
- **Location Bar**: Shows current location with icon
- **Search Field**: Real-time search with autocomplete disabled
- **Loading Indicator**: ProgressView during API calls
- **Place Cards**: Beautiful cards with place information

**SwiftUI Features Used:**
- `@StateObject`: Creates and owns observable objects
- `@State`: Manages local view state
- `.onChange(of:)`: Reacts to search text changes
- `LazyVStack`: Efficient scrolling for large lists

---

## 🔧 How It Works

### Search Flow

```
User types "ATM"
      ↓
ContentView detects change (.onChange)
      ↓
ViewModel.search() is called
      ↓
Validates input & location
      ↓
Sets isLoading = true
      ↓
PlacesAPIService makes HTTP request
      ↓
Google Places API returns JSON
      ↓
Parse JSON → [Place] array
      ↓
Update ViewModel.places
      ↓
SwiftUI automatically updates UI
      ↓
User sees results!
```

### Location Flow

```
App Launches
      ↓
LocationManager.init()
      ↓
Request location permission
      ↓
User grants permission
      ↓
Start location updates
      ↓
Receive location coordinates
      ↓
Reverse geocode (coordinates → address)
      ↓
Update locationName
      ↓
Stop location updates (save battery)
```

---

## 🎯 Usage Examples

### Basic Search
1. Open the app
2. Wait for location to load
3. Type "restaurant" in search field
4. View nearby restaurants instantly

### Specific Searches
- **"ATM near me"** → Find nearby ATMs
- **"24 hour pharmacy"** → Find late-night pharmacies
- **"coffee shop"** → Find coffee shops
- **"gas station"** → Find gas stations

### Search Tips
- Be specific: "Italian restaurant" vs "restaurant"
- Use common terms Google recognizes
- Wait for location to load for best results
- Search requires at least 2 characters

---

## 🛠️ Customization

### Change Search Radius
In `PlacesAPIService.swift`:
```swift
&radius=5000  // Change to 1000 for 1km, 10000 for 10km
```

### Modify Place Card Design
In `ContentView.swift`, update `PlaceCardView`:
```swift
struct PlaceCardView: View {
    var body: some View {
        // Customize colors, fonts, spacing here
    }
}
```

### Add More Place Properties
1. Update `Place.swift` model
2. Parse additional fields in `PlacesAPIService.swift`
3. Display in `PlaceCardView`

---

## ⚠️ Known Limitations

1. **API Key Exposure**: API key is in source code (use environment variables in production)
2. **No Caching**: Results aren't cached (implement caching for better performance)
3. **Limited Error UI**: Errors only printed to console (add user-facing error messages)
4. **No Offline Mode**: Requires internet connection
5. **Single Result Page**: No pagination for large result sets

---

## 🚀 Future Enhancements

### Phase 1: Production Ready
- [ ] Add proper error handling UI
- [ ] Implement empty state views
- [ ] Add retry mechanism for failed requests
- [ ] Store API key securely (Keychain/Environment)
- [ ] Add permission denied UI

### Phase 2: Enhanced Features
- [ ] Map view with place markers
- [ ] Detailed place view (photos, reviews, hours)
- [ ] Favorites/Bookmarks system
- [ ] Filter by rating, distance, open now
- [ ] Share place information

### Phase 3: Advanced
- [ ] Offline caching with Core Data
- [ ] Search history
- [ ] Route navigation integration
- [ ] User reviews and ratings
- [ ] Voice search
- [ ] AR navigation

---

## 🧪 Testing

### Manual Testing Checklist
- [ ] Search with valid query returns results
- [ ] Search with invalid query shows empty state
- [ ] Location permission denied shows appropriate message
- [ ] Loading indicator appears during search
- [ ] Location updates correctly
- [ ] App handles no internet connection gracefully

### Device Testing
Test on:
- iPhone SE (smallest screen)
- iPhone 14 Pro (notch/dynamic island)
- iPhone 14 Pro Max (largest screen)
- iPad (different layout)

---

## 🐛 Troubleshooting

### No Results Appearing
- Check API key is valid
- Verify Places API is enabled in Google Cloud
- Check internet connection
- Ensure location permission is granted
- Look at Xcode console for API errors

### Location Not Working
- Check Info.plist has location permission description
- Verify location permission is granted in Settings
- Try resetting location permissions
- Test on real device (simulator has issues)

### Build Errors
- Clean build folder: `Cmd + Shift + K`
- Delete derived data
- Restart Xcode
- Check Swift version compatibility

---

## 📚 Learning Resources

### SwiftUI
- [Apple SwiftUI Documentation](https://developer.apple.com/documentation/swiftui/)
- [Hacking with Swift](https://www.hackingwithswift.com/quick-start/swiftui)
- [SwiftUI by Example](https://www.hackingwithswift.com/quick-start/swiftui)

### Core Location
- [Apple Core Location Guide](https://developer.apple.com/documentation/corelocation)
- [Ray Wenderlich Location Tutorial](https://www.raywenderlich.com/5247-core-location-tutorial-for-ios-tracking-visited-locations)

### Google Places API
- [Places API Documentation](https://developers.google.com/maps/documentation/places/web-service)
- [Text Search Requests](https://developers.google.com/maps/documentation/places/web-service/search-text)

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Contribution Guidelines
- Follow Swift style guide
- Add comments for complex logic
- Test on multiple devices
- Update README if needed

---

## 📄 License

This project is licensed under the MIT License - see below for details:

```
MIT License

Copyright (c) 2026 Noman Belim

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

 
---

## 🙏 Acknowledgments

- **Google Places API** for providing place data
- **Apple** for SwiftUI and Core Location frameworks
- **iOS Developer Community** for inspiration and support
 
---

## 📊 Project Stats

- **Lines of Code**: ~400
- **Files**: 5
- **Dependencies**: 0 (only native iOS frameworks)
- **Minimum iOS Version**: 15.0
- **Development Time**: ~8 hours

---

## 🎓 What You'll Learn

By studying this project, you'll understand:

✅ **SwiftUI Fundamentals**
- View composition and modifiers
- State management with @State and @StateObject
- Observable objects and @Published properties

✅ **MVVM Architecture**
- Separation of concerns
- View ↔ ViewModel communication
- Data binding

✅ **Networking**
- URLSession basics
- JSON parsing
- Asynchronous operations
- Completion handlers

✅ **Location Services**
- Core Location framework
- Permission handling
- Reverse geocoding
- Battery optimization

✅ **iOS Best Practices**
- Memory management with weak references
- Main thread UI updates
- Error handling
- User privacy

---
 
