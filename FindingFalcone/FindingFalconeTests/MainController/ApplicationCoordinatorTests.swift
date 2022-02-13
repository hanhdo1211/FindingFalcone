
import XCTest

@testable import FindingFalcone
import UIKit

class ApplicationCoordinatorTests: XCTestCase {

    private var mockWindow: MockWindow!
    private var mockModalNavigationController: ModalNavigationController!
    private var coordinator: ApplicationCoordinator!
    
    override func setUp() {
        super.setUp()
        configure()
    }

    override func tearDown() {
        mockWindow = nil
        mockModalNavigationController = nil
        coordinator = nil
        super.tearDown()
    }

    private func configure() {
        mockWindow = MockWindow()
        mockModalNavigationController = ModalNavigationController()
        coordinator = ApplicationCoordinator(
            window: mockWindow,
            navigationController: mockModalNavigationController
        )
    }
    
    func testStart() {
        // When
        coordinator.start()
        
        // Then
        XCTAssertEqual(mockWindow.makeKeyAndVisibleCalledCount, 1)
        XCTAssertTrue(mockWindow.rootViewController === mockModalNavigationController)
        XCTAssertEqual(coordinator.childCoordiantors.count, 1)
        XCTAssertTrue(coordinator.childCoordiantors.last is SelectPlanetsCoordinator)
        XCTAssertTrue(mockModalNavigationController.viewControllers.last is SelectPlanetsViewController)
    }

}
