import UIKit

final class ApplicationCoordinator: Coordinating {
    weak var parentCoordiantor: Coordinating?
    var childCoordiantors: [Coordinating] = []
    var navigationController: ModalNavigationController
    
    private var window: WindowRepresentable
    
    init(
        parentCoordiantor: Coordinating? = nil,
        window: WindowRepresentable,
        navigationController: ModalNavigationController = ModalNavigationController()
    ) {
        self.parentCoordiantor = parentCoordiantor
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
            parentCoordiantor: self,
            navigationController: navigationController
        )
        coordinator.start()
        childCoordiantors.append(coordinator)
    }
}
