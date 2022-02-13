@testable import FindingFalcone
import UIKit

final class MockCoordinator: Coordinating {
    var navigationController: ModalNavigationControlling = MockModalNavigationController()
    
    var parentCoordinator: Coordinating?
    var childCoordinators: [Coordinating] = []
    
    private(set) var childCoordinatorDidFinishCalledCount: Int = 0
    private(set) var childCoordinatorDidFinishCoordinator: Coordinating?
    func childCoordinatorDidFinish(_ coordinator: Coordinating) {
        childCoordinatorDidFinishCalledCount += 1
        childCoordinatorDidFinishCoordinator = coordinator
    }
    
}
