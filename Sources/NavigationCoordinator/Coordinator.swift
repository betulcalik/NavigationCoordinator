//
//  Coordinator.swift
//  NavigationCoordinator
//
//  Created by Betül Çalık on 9.05.2025.
//

import SwiftUI

public protocol Coordinator: ObservableObject {
    associatedtype Route: Hashable
    associatedtype Content: View

    var path: NavigationPath { get set }

    @ViewBuilder func build(route: Route) -> Content

    func navigate(to route: Route)
    func pop()
    func removeLast(_ k: Int)
}

public extension Coordinator {
    func navigate(to route: Route) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func removeLast(_ k: Int) {
        guard k <= path.count else {
            path.removeLast(path.count)
            return
        }
        path.removeLast(k)
    }
}
