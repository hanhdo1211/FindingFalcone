import Foundation

protocol SelectPlanetsDisplaying: Display {
    func set(sections: [TableViewSectionItem])
    func showError(message: String)
}

protocol SelectPlanetsPresenting {
    func displayDidLoad()
}

protocol SelectPlanetsCoordinatorPresentingDelegate: class {
    func showSelectVehicles(selectedPlanets: [SelectPlanetsItem], completion: @escaping ButtonAction)
}

final class SelectPlanetsPresenter {
    private weak var display: SelectPlanetsDisplaying!
    private weak var coordinator: SelectPlanetsCoordinatorPresentingDelegate!
    private var sections: [TableViewSectionItem] = []
    private var selectPlanetsItems: [SelectPlanetsItem] = []
    private let network: Networking
    init(
        display: SelectPlanetsDisplaying,
        coordinator: SelectPlanetsCoordinatorPresentingDelegate,
        network: Networking = NetwokClient()
    ) {
        self.display = display
        self.coordinator = coordinator
        self.network = network
    }
}

extension SelectPlanetsPresenter: SelectPlanetsPresenting {
    func displayDidLoad() {
        self.fetchPlanets()
    }
}

private extension SelectPlanetsPresenter {
    func fetchPlanets() {
        display.show(loading: true)
        self.network.getPlanets {[weak self] (response) in
            self?.display.show(loading: false)
            switch response {
            case .success(let planets):
                self?.buildSections(planets: planets)
            case .failure( _):
                // TODO: Handle error
                break
            }
        }
    }
    
    func buildSections(planets: [PlantResponse]) {
        buildPlanets(planets: planets) { [weak self] (planetName, isSelected) in
            if let index = self?.selectPlanetsItems.firstIndex(where: {$0.name == planetName}) {
                self?.selectPlanetsItems[index].isSelected = isSelected
            }
        }
        self.display.set(sections: sections)
    }
    
    func buildPlanets(planets: [PlantResponse], action: @escaping (String, Bool) -> Void) {
        selectPlanetsItems = planets.compactMap { planet in
            SelectPlanetsItem(
                name: planet.name,
                distance: planet.distance,
                isSelected: false) { (isSelected) in
                action(planet.name, isSelected)
            }
        }
        
        let footerItem = SelectPlanetsFooterItem(
            note: "Select 4 planets",
            buttonName: "NEXT") { [weak self] in
            self?.handleNextAction()
        }
        
        sections = [
            TableViewSectionItem(items: selectPlanetsItems, footer: footerItem)
        ]
    }
}

private extension SelectPlanetsPresenter {
    func validateNumOfSelectedPlanets() -> Bool {
        let numOfSelected = self.selectPlanetsItems.filter { $0.isSelected }.count
        return numOfSelected == 4
    }
    
    func handleNextAction() {
        guard validateNumOfSelectedPlanets() else {
            display.showError(message: "Please select 4 planets to continue!")
            return
        }
        coordinator.showSelectVehicles(
            selectedPlanets: self.selectPlanetsItems.filter { $0.isSelected }) { [weak self] in
            self?.fetchPlanets()
        }
    }
}
