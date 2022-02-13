import XCTest

@testable import FindingFalcone
import UIKit

class SelectPlanetsCoordiantorTests: XCTestCase {

    private var mockParentCoordinator: MockCoordinating!
    private var mockModalNavigationController: ModalNavigationController!
    private var coordinator: SelectPlanetsCoordinator!
    
    override func setUp() {
        super.setUp()
        configure()
    }

    override func tearDown() {
        mockParentCoordinator = nil
        mockModalNavigationController = nil
        coordinator = nil
        super.tearDown()
    }
    
    private func configure() {
        mockParentCoordinator = MockCoordinating()
        mockModalNavigationController = ModalNavigationController()
        coordinator = SelectPlanetsCoordinator(
            parentCoordiantor: mockParentCoordinator,
            navigationController: mockModalNavigationController
        )
    }

    func testStart() {
        // When
        coordinator.start()
        
        // Then
        XCTAssertTrue(coordinator.parentCoordiantor === mockParentCoordinator)
        XCTAssertTrue(mockModalNavigationController.viewControllers.last is SelectPlanetsViewController)
    }
    
    func testShowSelectVehicles() {
        // When
        coordinator.showSelectVehicles(selectedPlanets: [], completion: {})
        
        // Then
        XCTAssertEqual(coordinator.childCoordiantors.count, 1)
        XCTAssertTrue(coordinator.childCoordiantors.last is SelectVehiclesCoordinator)
    }

}
