import UIKit

final class ApplicationCoordinator: Coordinating {
    weak var parentCoordinator: Coordinating?
    var childCoordinators: [Coordinating] = []
    var navigationController: ModalNavigationControlling
    
    private var window: WindowRepresentable
    
    init(
        parentCoordinator: Coordinating? = nil,
        window: WindowRepresentable,
        navigationController: ModalNavigationControlling = ModalNavigationController()
    ) {
        self.parentCoordinator = parentCoordinator
        self.navigationController = navigationController
        self.window = window
    }
    
    
    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        showSelectPlanets()
    }
    
    func showSelectPlanets() {
        let coordinator = SelectPlanetsCoordinator(
            parentCoordinator: self,
            navigationController: navigationController
        )
        coordinator.start()
        childCoordinators.append(coordinator)
    }
}
