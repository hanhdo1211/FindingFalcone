import UIKit

final class SelectVehiclesCoordinator: Coordinating {
    
    weak var parentCoordiantor: Coordinating?
    var childCoordiantors: [Coordinating] = []
    var navigationController: ModalNavigationController
    
    private var completion: ButtonAction?
    
    init(
        parentCoordiantor: Coordinating? = nil,
        navigationController: ModalNavigationController
    ) {
        self.parentCoordiantor = parentCoordiantor
        self.navigationController = navigationController
        
    }
    
    func start(with planets: [SelectPlanetsItem], completion: @escaping ButtonAction) {
        self.completion = completion
        let controller = SelectVehiclesViewController()
        let presenter = SelectVehiclesPresenter(
            display: controller,
            coordinator: self,
            planetItems: planets
        )
        controller.presenter = presenter
        
        navigationController.pushViewController(controller, animated: true) { [weak self] in
            self?.coordinatorDidFinish()
        }
    }
    
}

extension SelectVehiclesCoordinator: SelectVehiclesCoordinatorPresentingDelegate {
    func finishFinding() {
        completion?()
        self.navigationController.popViewController(animated: true)
        self.coordinatorDidFinish()
    }
}
