@testable import FindingFalcone
import UIKit

final class MockCoordinating: Coordinating {
    var navigationController: ModalNavigationController = ModalNavigationController()
    
    var parentCoordiantor: Coordinating?
    var childCoordiantors: [Coordinating] = []
    
    private(set) var childCoordinatorDidFinishCalledCount: Int = 0
    private(set) var childCoordinatorDidFinishCoordinator: Coordinating?
    func childCoordinatorDidFinish(_ coordinator: Coordinating) {
        childCoordinatorDidFinishCalledCount += 1
        childCoordinatorDidFinishCoordinator = coordinator
    }
    
}
