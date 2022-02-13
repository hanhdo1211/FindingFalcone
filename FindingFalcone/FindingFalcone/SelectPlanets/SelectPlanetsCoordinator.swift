import UIKit

final class SelectPlanetsCoordinator: Coordinating {
    weak var parentCoordinator: Coordinating?
    var childCoordinators: [Coordinating] = []
    var navigationController: ModalNavigationControlling
    
    init(
        parentCoordinator: Coordinating? = nil,
        navigationController: ModalNavigationControlling
    ) {
        self.parentCoordinator = parentCoordinator
        self.navigationController = navigationController
    }
    
    func start() {
        let controller = SelectPlanetsViewController()
        let presenter = SelectPlanetsPresenter(display: controller,
                                               coordinator: self)
        controller.presenter = presenter
        navigationController.pushViewController(controller, animated: true, popHandler: nil)
    }
    
}

extension SelectPlanetsCoordinator: SelectPlanetsCoordinatorPresentingDelegate {
    func showSelectVehicles(selectedPlanets: [SelectPlanetsItem], completion: @escaping ButtonAction) {
        let coordinator = SelectVehiclesCoordinator(
            parentCoordinator: self,
            navigationController: self.navigationController
        )
        
        coordinator.start(with: selectedPlanets, completion: completion)
        childCoordinators.append(coordinator)
    }
}
