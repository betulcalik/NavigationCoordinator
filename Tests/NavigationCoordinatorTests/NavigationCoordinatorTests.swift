import XCTest
import SwiftUI
@testable import NavigationCoordinator

final class NavigationCoordinatorTests: XCTestCase {
    enum TestRoute: Hashable {
        case first
        case second
    }
    
    final class TestCoordinator: Coordinator {
        var path: NavigationPath = NavigationPath()
        
        @ViewBuilder
        func build(route: TestRoute) -> some View {
            switch route {
            case .first:
                Text("First")
            case .second:
                Text("Second")
            }
        }
    }
    
    func testNavigateAppendsRoute() {
        let coordinator = TestCoordinator()
        XCTAssertEqual(coordinator.path.count, 0)
        
        coordinator.navigate(to: .first)
        XCTAssertEqual(coordinator.path.count, 1)
    }
    
    func testPopRemovesLastRoute() {
        let coordinator = TestCoordinator()
        coordinator.navigate(to: .first)
        coordinator.navigate(to: .second)
        XCTAssertEqual(coordinator.path.count, 2)
        
        coordinator.pop()
        XCTAssertEqual(coordinator.path.count, 1)
    }
    
    func testRemoveLast() {
        let coordinator = TestCoordinator()
        coordinator.navigate(to: .first)
        coordinator.navigate(to: .second)
        coordinator.navigate(to: .first)
        
        coordinator.removeLast(2)
        XCTAssertEqual(coordinator.path.count, 1)
    }
    
    func testRemoveLastMoreThanCount() {
        let coordinator = TestCoordinator()
        coordinator.navigate(to: .first)
        
        coordinator.removeLast(5)
        XCTAssertEqual(coordinator.path.count, 0)
    }
}
