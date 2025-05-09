//
//  AppCoordinator.swift
//  NavigationCoordinator
//
//  Created by Betül Çalık on 9.05.2025.
//

import SwiftUI

open class AppCoordinator<Tab: Hashable>: ObservableObject {
    @Published public var selectedTab: Tab

    public init(initialTab: Tab) {
        self.selectedTab = initialTab
    }

    public func switchTab(to tab: Tab) {
        selectedTab = tab
    }
}
