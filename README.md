# Navigation Coordinator for SwiftUI
Navigation Coordinator is a Swift package designed to simplify navigation in SwiftUI applications. It provides a clean and structured approach to managing navigation stacks and tab flows using the Coordinator pattern, promoting modular and maintainable code architecture.

## Features
- Easily navigate between views and manage navigation stack.  
- Organize and decouple navigation logic by encapsulating it within coordinators.  
- Supports custom tab navigation with flexible tab types.  
- Each coordinator can manage its own navigation stack.

## Installation

### Swift Package Manager

To integrate Navigation Coordinator into your project using Swift Package Manager, add the following as a dependency to your `Package.swift`:
```
dependencies: [ .package(url: "https://github.com/betulcalik/NavigationCoordinator.git", from: "1.0.0") ]
```

Alternatively, you can navigate to your Xcode project, select Swift Packages, and click the "+" icon to search for `NavigationCoordinator`.

## Usage

### Coordinator Implementation
First, let's define the components of our navigation system:
```swift
// Define a coordinator for your tab
final class HomeCoordinator: BaseCoordinator<HomeCoordinator.Route, MyAppCoordinator.Tab>, Coordinator {
    enum Route: Hashable {
        case settings
    }
    
    @Published var path = NavigationPath()

    // Define your tab routes in here
    override func build(route: Route) -> AnyView {
        switch route {
        case .settings:
            return AnyView(SettingsView())
        }
    }
}
```

### App Coordinator Setup
The main app coordinator manages all tab coordinators:
```swift
/// Define your own coordinator with your own tabs
final class MyAppCoordinator: AppCoordinator<MyAppCoordinator.Tab> {
    enum Tab {
        case home
        case profile
    }
    
    let homeCoordinator: HomeCoordinator
    let profileCoordinator: ProfileCoordinator
    
    init() {
        self.homeCoordinator = HomeCoordinator()
        self.profileCoordinator = ProfileCoordinator()
        super.init(initialTab: .home)
        homeCoordinator.appCoordinator = self
        profileCoordinator.appCoordinator = self
    }
}

// App entry point
@main
struct ExampleApp: App {
    @StateObject private var appCoordinator = MyAppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            BaseTabView()
                .environmentObject(appCoordinator)
        }
    }
}
```

### 1) Tab Navigation
Each tab has its own coordinator view that sets up the navigation:
```swift
struct BaseTabView: View {
    @EnvironmentObject var appCoordinator: MyAppCoordinator
    
    var body: some View {
        TabView(selection: $appCoordinator.selectedTab) {
            HomeCoordinatorView()
                .environmentObject(appCoordinator.homeCoordinator)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(MyAppCoordinator.Tab.home)
            
            ProfileCoordinatorView()
                .environmentObject(appCoordinator.profileCoordinator)
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(MyAppCoordinator.Tab.profile)
        }
    }
}

// Connect HomeView to the navigation system
struct HomeCoordinatorView: View {
    @EnvironmentObject var coordinator: HomeCoordinator
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            HomeView()
                .navigationDestination(for: HomeCoordinator.Route.self) { route in
                    coordinator.build(route: route)
                }
        }
    }
}
```

To switch between tabs programmatically:
```swift
appCoordinator.switchTab(to: .profile)
```

### 2) In Tab Navigation
Navigate between views within a tab using the coordinator:
```swift
struct HomeView: View {
    @EnvironmentObject var coordinator: HomeCoordinator
    
    var body: some View {
        VStack {
            Text("Home View")
                .font(.largeTitle)
            
            Button("Go to Settings") {
                coordinator.navigate(to: .settings)
            }
            .padding()
        }
        .navigationTitle("Home")
    }
}

struct SettingsView: View {
    @EnvironmentObject var coordinator: HomeCoordinator
    
    var body: some View {
        VStack {
            Text("Settings View")
                .font(.largeTitle)
            
            Button("Go Back") {
                coordinator.pop()
            }
            .padding()
        }
        .navigationTitle("Settings")
    }
}
```

## Requirements
- iOS 16.0+

## License
Navigation Coordinator is available under the MIT license. See the LICENSE file for more info.
