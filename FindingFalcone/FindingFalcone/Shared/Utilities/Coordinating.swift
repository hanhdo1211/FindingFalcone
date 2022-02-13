import UIKit

protocol Coordinating: class {
    var parentCoordiantor: Coordinating? { get }
    var childCoordiantors: [Coordinating] { get set }
    var navigationController: ModalNavigationController { get }
    
    func coordinatorDidFinish()
    func childCoordinatorDidFinish(_ coordinator: Coordinating)
    
    func start()
}

extension Coordinating {
    func coordinatorDidFinish() {
        parentCoordiantor?.childCoordinatorDidFinish(self)
    }
    
    func childCoordinatorDidFinish(_ coordinator: Coordinating) {
        childCoordiantors = childCoordiantors.filter { $0 !== coordinator }
    }
    
    func start() {
        assertionFailure("This method needs to be implemented")
    }
}
