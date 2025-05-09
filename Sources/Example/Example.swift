//
//  Example.swift
//  NavigationCoordinator
//
//  Created by Betül Çalık on 9.05.2025.
//
import SwiftUI
import NavigationCoordinator

// MARK: - App Entry Point
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

// MARK: - Base Tab View
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

// MARK: - Coordinators
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

// MARK: - Home Coordinator
final class HomeCoordinator: BaseCoordinator<HomeCoordinator.Route, MyAppCoordinator.Tab>, Coordinator {
    enum Route: Hashable {
        case settings
    }

    @Published var path = NavigationPath()

    func build(route: Route) -> some View {
        switch route {
        case .settings:
            return SettingsView()
        }
    }
}

// MARK: - Profile Coordinator
final class ProfileCoordinator: BaseCoordinator<ProfileCoordinator.Route, MyAppCoordinator.Tab>, Coordinator {
    enum Route: Hashable {
        case details
    }

    @Published var path = NavigationPath()

    func build(route: Route) -> some View {
        switch route {
        case .details:
            return ProfileDetailsView()
        }
    }
}

// MARK: - Coordinator Views
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

struct ProfileCoordinatorView: View {
    @EnvironmentObject var coordinator: ProfileCoordinator

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            ProfileView()
                .navigationDestination(for: ProfileCoordinator.Route.self) { route in
                    coordinator.build(route: route)
                }
        }
    }
}

// MARK: - Views
struct HomeView: View {
    @EnvironmentObject var coordinator: HomeCoordinator

    var body: some View {
        VStack {
            Text("🏠 Home View")
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
            Text("⚙️ Settings View")
                .font(.largeTitle)

            Button("Go Back") {
                coordinator.pop()
            }
            .padding()
        }
        .navigationTitle("Settings")
    }
}

struct ProfileView: View {
    @EnvironmentObject var coordinator: ProfileCoordinator

    var body: some View {
        VStack {
            Text("👤 Profile View")
                .font(.largeTitle)

            Button("Go to Details") {
                coordinator.navigate(to: .details)
            }
            .padding()
        }
        .navigationTitle("Profile")
    }
}

struct ProfileDetailsView: View {
    @EnvironmentObject var coordinator: ProfileCoordinator

    var body: some View {
        VStack {
            Text("📄 Profile Details")
                .font(.largeTitle)

            Button("Back") {
                coordinator.pop()
            }
            .padding()
        }
        .navigationTitle("Details")
    }
}
