import XCTest

@testable import FindingFalcone
import UIKit

final class SelectVehiclesCoordinatorTests: XCTestCase {

    private var mockParentCoordinator: MockCoordinator!
    private var mockModalNavigationController: MockModalNavigationController!
    private var coordinator: SelectVehiclesCoordinator!
    
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
        mockParentCoordinator = MockCoordinator()
        mockModalNavigationController = MockModalNavigationController()
        coordinator = SelectVehiclesCoordinator(
            parentCoordinator: mockParentCoordinator,
            navigationController: mockModalNavigationController
        )
    }
    
    func testStart() {
        // Given
        var completionCalledCount: Int = 0
        
        // When
        coordinator.start(with: [], completion: {
            completionCalledCount += 1
        })
        
        // Then
        XCTAssertTrue(coordinator.parentCoordinator === mockParentCoordinator)
        XCTAssertEqual(mockModalNavigationController.pushViewControllerCalledCount, 1)
        XCTAssertTrue(mockModalNavigationController.pushViewControllerViewController is SelectVehiclesViewController)
        XCTAssertNotNil(mockModalNavigationController.pushViewControllerPopHandler)
        XCTAssertEqual(completionCalledCount, 0)
        
        // When
        mockModalNavigationController.pushViewControllerPopHandler?()
        
        // Then
        XCTAssertEqual(completionCalledCount, 0)
        XCTAssertEqual(mockParentCoordinator.childCoordinatorDidFinishCalledCount, 1)
        XCTAssertTrue(mockParentCoordinator.childCoordinatorDidFinishCoordinator is SelectVehiclesCoordinator)
    }
    
    func testFinishFinding() {
        // Given
        var completionCalledCount:Int = 0
        coordinator.start(with: [], completion: {
            completionCalledCount += 1
        })
        
        // When
        coordinator.finishFinding()
        
        // Then
        XCTAssertEqual(completionCalledCount, 1)
        XCTAssertEqual(mockParentCoordinator.childCoordinatorDidFinishCalledCount, 1)
        XCTAssertTrue(mockParentCoordinator.childCoordinatorDidFinishCoordinator is SelectVehiclesCoordinator)
        XCTAssertEqual(mockModalNavigationController.popViewControllerCalledCount, 1)
    }
}
