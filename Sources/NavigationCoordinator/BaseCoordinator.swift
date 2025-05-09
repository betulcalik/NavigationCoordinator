//
//  BaseCoordinator.swift
//  NavigationCoordinator
//
//  Created by Betül Çalık on 9.05.2025.
//

import SwiftUI

open class BaseCoordinator<Route: Hashable, Tab: Hashable>: ObservableObject {
    public weak var appCoordinator: AppCoordinator<Tab>?

    public init(appCoordinator: AppCoordinator<Tab>? = nil) {
        self.appCoordinator = appCoordinator
    }

    open func build(route: Route) -> AnyView {
        return AnyView(EmptyView())
    }
}
