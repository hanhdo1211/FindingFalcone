import UIKit

final class SelectPlanetsCoordinator: Coordinating {
    weak var parentCoordiantor: Coordinating?
    var childCoordiantors: [Coordinating] = []
    var navigationController: ModalNavigationController
    
    init(
        parentCoordiantor: Coordinating? = nil,
        navigationController: ModalNavigationController
    ) {
        self.parentCoordiantor = parentCoordiantor
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
            parentCoordiantor: self,
            navigationController: self.navigationController
        )
        
        coordinator.start(with: selectedPlanets, completion: completion)
        childCoordiantors.append(coordinator)
    }
}
