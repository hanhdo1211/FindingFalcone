import Foundation
@testable import FindingFalcone

final class MockNetwokClient: Networking {
    
    private(set) var getPlanetsCalledCount: Int = 0
    private(set) var getPlanetsCompletion: Action<Result<[PlantResponse], APIError>>?
    func getPlanets(completion: @escaping Action<Result<[PlantResponse], APIError>>) {
        getPlanetsCalledCount += 1
        getPlanetsCompletion = completion
    }
    
    private(set) var getVehiclesCalledCount: Int = 0
    private(set) var getVehiclesCompletion: Action<Result<[VehicleResponse], APIError>>?
    func getVehicles(completion: @escaping Action<Result<[VehicleResponse], APIError>>) {
        getVehiclesCalledCount += 1
        getVehiclesCompletion = completion
    }
    
    private(set) var genTokenCalledCount: Int = 0
    private(set) var genTokenCompletion: Action<Result<TokenResponse, APIError>>?
    func genToken(completion: @escaping Action<Result<TokenResponse, APIError>>) {
        genTokenCalledCount += 1
        genTokenCompletion = completion
    }
    
    private(set) var submitFindCalledCount: Int = 0
    private(set) var submitFindData: FindData?
    private(set) var submitFindCompletion: Action<Result<FindResponse, APIError>>?
    func submitFind(data: FindData, completion: @escaping Action<Result<FindResponse, APIError>>) {
        submitFindCalledCount += 1
        submitFindData = data
        submitFindCompletion = completion
    }
}
