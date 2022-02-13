import Foundation
import UIKit

final class PlanetVehicleItem {
    let planet: String
    var vehicle: String?
    let primaryAction: ButtonAction
    let removeAction: ButtonAction
    var timeTaken: Int = 0
    
    init(
        planet: String,
        vehicle: String? = nil,
        primaryAction: @escaping ButtonAction,
        removeAction: @escaping ButtonAction
    ) {
        self.planet = planet
        self.vehicle = vehicle
        self.primaryAction = primaryAction
        self.removeAction = removeAction
    }
    
    func removeVehicle() {
        self.vehicle = nil
        self.timeTaken = 0
    }
}

extension PlanetVehicleItem: CellDisplayable {
    func extracCell(from tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        let cell: PlanetVehicleCell = tableView.dequeueReusable(at: indexPath)
        cell.configure(with: self)
        return cell
    }
}
