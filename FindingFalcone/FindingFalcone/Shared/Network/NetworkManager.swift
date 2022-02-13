import Foundation
import Alamofire

protocol Networking {
    func getPlanets(completion: @escaping Action<Result<[PlantResponse], APIError>>)
    func getVehicles(completion: @escaping Action<Result<[VehicleResponse], APIError>>)
    func genToken(completion: @escaping Action<Result<TokenResponse, APIError>>)
    func submitFind(data: FindData, completion: @escaping Action<Result<FindResponse, APIError>>)
}

enum APIError: Error {
    case noInternet
    case timeout
    case general
}

final class NetwokClient: Networking {
    private let baseURL: String = "https://findfalcone.herokuapp.com"
    
    func getPlanets(completion: @escaping Action<Result<[PlantResponse], APIError>>) {
        AF.request(baseURL + "/planets")
            .responseDecodable(of: [PlantResponse].self) { (response) in
                switch response.result {
                case .success(let planets):
                    completion(.success(planets))
                case .failure(let error):
                    completion(.failure(error.apiError))
                }
            }
    }
    
    func getVehicles(completion: @escaping Action<Result<[VehicleResponse], APIError>>) {
        AF.request(baseURL + "/vehicles")
            .responseDecodable(of: [VehicleResponse].self) { (response) in
                switch response.result {
                case .success(let planets):
                    completion(.success(planets))
                case .failure(let error):
                    completion(.failure(error.apiError))
                }
            }
    }
    
    func genToken(completion: @escaping Action<Result<TokenResponse, APIError>>) {
        let headers: HTTPHeaders = [
            .accept("application/json")
        ]
        
        AF.request(baseURL + "/token", method: .post, headers: headers)
            .responseDecodable(of: TokenResponse.self) { (response) in
                switch response.result {
                case .success(let token):
                    completion(.success(token))
                case .failure(let error):
                    completion(.failure(error.apiError))
                }
            }
    }
    
    func submitFind(data: FindData, completion: @escaping Action<Result<FindResponse, APIError>>) {
        let headers: HTTPHeaders = [
            .accept("application/json"),
            .contentType("application/json")
            
        ]
        AF.request(
            baseURL + "/find",
            method: .post,
            parameters: data,
            encoder: JSONParameterEncoder.default,
            headers: headers
        )
        .responseDecodable(of: FindResponse.self) { (response) in
            switch response.result {
            case .success(let result):
                if result.error != nil {
                    completion(.failure(APIError.general))
                    return
                }
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error.apiError))
            }
        }
    }
}

private extension AFError {
    var apiError: APIError {
        switch (self as NSError).code {
        case NSURLErrorNotConnectedToInternet:
            return .noInternet
        case NSURLErrorTimedOut:
            return .timeout
        default:
            return .general
        }
    }
}
