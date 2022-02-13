import UIKit

protocol Coordinating: class {
    var parentCoordinator: Coordinating? { get }
    var childCoordinators: [Coordinating] { get set }
    var navigationController: ModalNavigationControlling { get }
    
    func coordinatorDidFinish()
    func childCoordinatorDidFinish(_ coordinator: Coordinating)
    
    func start()
}

extension Coordinating {
    func coordinatorDidFinish() {
        parentCoordinator?.childCoordinatorDidFinish(self)
    }
    
    func childCoordinatorDidFinish(_ coordinator: Coordinating) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
    
    func start() {
        assertionFailure("This method needs to be implemented")
    }
}
