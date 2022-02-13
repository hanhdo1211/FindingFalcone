import XCTest

@testable import FindingFalcone
import UIKit

final class SelectPlanetsCoordiantorTests: XCTestCase {

    private var mockCoordinator: MockCoordinator!
    private var mockModalNavigationController: MockModalNavigationController!
    private var coordinator: SelectPlanetsCoordinator!
    
    override func setUp() {
        super.setUp()
        configure()
    }

    override func tearDown() {
        mockCoordinator = nil
        mockModalNavigationController = nil
        coordinator = nil
        super.tearDown()
    }
    
    private func configure() {
        mockCoordinator = MockCoordinator()
        mockModalNavigationController = MockModalNavigationController()
        coordinator = SelectPlanetsCoordinator(
            parentCoordinator: mockCoordinator,
            navigationController: mockModalNavigationController
        )
    }

    func testStart() {
        // When
        coordinator.start()
        
        // Then
        XCTAssertTrue(coordinator.parentCoordinator === mockCoordinator)
        XCTAssertEqual(mockModalNavigationController.pushViewControllerCalledCount, 1)
        XCTAssertTrue(mockModalNavigationController.pushViewControllerViewController is SelectPlanetsViewController)
    }
    
    func testShowSelectVehicles() {
        // When
        coordinator.showSelectVehicles(selectedPlanets: [], completion: {})
        
        // Then
        XCTAssertEqual(coordinator.childCoordinators.count, 1)
        XCTAssertTrue(coordinator.childCoordinators.last is SelectVehiclesCoordinator)
    }

}
