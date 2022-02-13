//
//  MockSelectPlanetsCoordinator.swift
//  FindingFalconeTests
//
//  Created by Hanh Do on 13/02/2022.
//

import Foundation
@testable import FindingFalcone
import UIKit

final class MockSelectPlanetsCoordinator: SelectPlanetsCoordinatorPresentingDelegate {
    
    private(set) var showSelectVehiclesCalledCount: Int = 0
    private(set) var showSelectVehiclesSelectedPlanets: [SelectPlanetsItem]?
    private(set) var showSelectVehiclesCompletion: ButtonAction?
    
    func showSelectVehicles(selectedPlanets: [SelectPlanetsItem], completion: @escaping ButtonAction) {
        showSelectVehiclesCalledCount += 1
        showSelectVehiclesSelectedPlanets = selectedPlanets
        showSelectVehiclesCompletion = completion
    }
}
