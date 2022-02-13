import Foundation
import Foundation

protocol SelectVehiclesDisplaying: Display {
    func set(sections: [TableViewSectionItem])
    func showError(message: String)
    func showSelectVehicle(_ selectVehicleItems: [SelectVehicleItem])
}

protocol SelectVehiclesPresenting {
    func displayDidLoad()
}

protocol SelectVehiclesCoordinatorPresentingDelegate: class {
    func finishFinding()
}

final class SelectVehiclesPresenter {
    private weak var display: SelectVehiclesDisplaying!
    private weak var coordinator: SelectVehiclesCoordinatorPresentingDelegate!
    private var sections: [TableViewSectionItem] = []
    private var planetVehicleItems: [PlanetVehicleItem] = []
    private let network: Networking
    private let planetItems: [SelectPlanetsItem]
    private var vehicleItems: [VehicleItem] = []
    
    init(
        display: SelectVehiclesDisplaying,
        coordinator: SelectVehiclesCoordinatorPresentingDelegate,
        network: Networking = NetwokClient(),
        planetItems: [SelectPlanetsItem] = []
    ) {
        self.display = display
        self.coordinator = coordinator
        self.network = network
        self.planetItems = planetItems
    }
}

extension SelectVehiclesPresenter: SelectVehiclesPresenting {
    func displayDidLoad() {
        self.fetchVerhicles()
    }
}

private extension SelectVehiclesPresenter {
    func fetchVerhicles() {
        display.show(loading: true)
        self.network.getVehicles {[weak self] (response) in
            self?.display.show(loading: false)
            switch response {
            case .success(let vehicles):
                self?.mappingVehicleItems(vehicles)
//                self?.vehicleItems = vehicles
                self?.buildSections()
            case .failure( _):
                // TODO: Handle error
                break
            }
        }
    }
    
    func mappingVehicleItems(_ vehicles: [VehicleResponse]) {
        self.vehicleItems = vehicles.compactMap {
            VehicleItem(
                name: $0.name,
                speed: $0.speed,
                totalSlots: $0.total_no,
                maxDistance: $0.max_distance
            )
        }
    }
    
    func buildSections() {
        buildPlanetVehicleList(
            planets: self.planetItems,
            actionSelect: {[weak self] planetName in
                self?.handleActionSelectVehicle(for: planetName)
            }, actionRemove: {[weak self] planetName in
                self?.handleActionRemoveVehicle(for: planetName)
            }
        )
        
        displaySection()
    }
    
    func buildPlanetVehicleList(
        planets: [SelectPlanetsItem],
        actionSelect: @escaping (String) -> Void,
        actionRemove: @escaping (String) -> Void
    ) {
        
        let planetVehicleItems = planets.compactMap { planet in
            PlanetVehicleItem(
                planet: planet.name,
                primaryAction: {
                    actionSelect(planet.name)
                }, removeAction: {
                    actionRemove(planet.name)
                })
        }
        self.planetVehicleItems = planetVehicleItems
    }
    
    func buildFooterItem() -> SelectPlanetsFooterItem {
        return SelectPlanetsFooterItem(
            note: "Assign vehicle for 4 planets",
            buttonName: "FIND FALCONE") { [weak self] in
            self?.handleNextAction()
        }
    }
    
    func displaySection() {
        sections = [
            TableViewSectionItem(items: planetVehicleItems, footer: self.buildFooterItem())
        ]
        self.display.set(sections: sections)
    }
}

private extension SelectVehiclesPresenter {
    func handleActionSelectVehicle(for planetName: String) {
        guard let planet = planetItems.first(where: {$0.name == planetName}) else { return }
        let availableVehicle = vehicleItems.filter { $0.availableSlots > 0 }
        let findableVehicle = availableVehicle.filter { $0.maxDistance >= planet.distance }
        
        let selectVehicleItems = findableVehicle.compactMap({ (vehicle) -> SelectVehicleItem in
            let item = SelectVehicleItem(
                text: "\(vehicle.name) - speed: \(vehicle.speed) - slot: \(vehicle.availableSlots)",
                action: { [weak self] in
                    self?.didSelect(vehicle: vehicle.name, for: planetName)
                })
            return item
        })
        
        display.showSelectVehicle(selectVehicleItems)
    }
    
    func handleActionRemoveVehicle(for planetName: String) {
        let planetVehicleItem = planetVehicleItems.first { $0.planet == planetName }
        guard let vehicleName = planetVehicleItem?.vehicle else { return }
        planetVehicleItem?.removeVehicle()
        let vehicleItem = self.vehicleItems.first { $0.name == vehicleName }
        vehicleItem?.updateAvailableSlots(value: (vehicleItem?.availableSlots ?? 0) + 1)
        
        self.displaySection()
    }
    
    func didSelect(vehicle: String, for planet: String) {
        guard let planetVehicleItem = planetVehicleItems.first(where: {$0.planet == planet}),
              let planet = planetItems.first(where: {$0.name == planet}),
              let vehicleItem = self.vehicleItems.first(where: {$0.name == vehicle})
        else { return }
        
        vehicleItem.updateAvailableSlots(value: vehicleItem.availableSlots - 1)
        planetVehicleItem.vehicle = vehicle
        let timeTaken = planet.distance / vehicleItem.speed
        planetVehicleItem.timeTaken = timeTaken
        
        self.displaySection()
    }
}

private extension SelectVehiclesPresenter {
    func validateNumOfSelectedPlanets() -> Bool {
        let numOfAssigned = self.planetVehicleItems.filter { $0.vehicle != nil }.count
        return numOfAssigned == 4
    }
    
    func handleNextAction() {
        guard validateNumOfSelectedPlanets() else {
            display.showError(message: "Please assign verhicles for 4 planets to continue!")
            return
        }
        display.show(loading: true)
        self.network.genToken {[weak self] (response) in
            self?.display.show(loading: false)
            switch response {
            case .success(let token):
                self?.submitFinding(with: token.token)
            case .failure( _):
                // TODO: Handle error
                break
            }
        }
    }
    
    func submitFinding(with toekn: String) {
        var planets: [String] = []
        var vehicles: [String] = []
        planetVehicleItems.forEach { (item) in
            planets.append(item.planet)
            if let vehicle = item.vehicle {
                vehicles.append(vehicle)
            }
        }
        let data = FindData(
            token: toekn,
            planet_names: planets,
            vehicle_names: vehicles
        )
        display.show(loading: true)
        self.network.submitFind(data: data) {[weak self] (response) in
            self?.display.show(loading: false)
            switch response {
            case .success(let result):
                self?.buildResultSection(with: result)
            case .failure( _):
                // TODO: Handle error
                break
            }
        }
    }
    
    func buildResultSection(with result: FindResponse) {
        let totalTimeTaken = planetVehicleItems.reduce(0, { $0 + $1.timeTaken })
        let resultMessage: String
        if result.status == "success" {
            resultMessage = "Success! Congratulations on Finding Falcone. King Shan is mighty pleased."
        } else {
            resultMessage = "Failed!"
        }
        let resultItem = FindingResultItem(
            timeTaken: totalTimeTaken,
            result: resultMessage,
            planetFound: result.planet_name,
            primaryAction: { [weak self] in
                self?.coordinator.finishFinding()
            }
        )
        display.set(sections: [TableViewSectionItem(items: [resultItem])])
    }
}
