//
//  DataProviderManager.swift
//  StarWarsHilde
//
//  Created by Hanine-EXT, Ayoub (uif25188) on 26/07/2022.
//

import Foundation
import Alamofire
import RxSwift

internal class DataProviderManager {
    static let shared = DataProviderManager()
    
    func makeRequest<T: Codable>(type: T.Type?, method: Alamofire.HTTPMethod = .get, url: URL, headers: HTTPHeaders? = nil, encoding: ParameterEncoding = URLEncoding.default) -> Observable<T> {
        return execRequest(type: type, method: method, url: url, headers: headers, encoding: encoding)
    }
    
    private func execRequest<T: Codable>(type: T.Type?, method: Alamofire.HTTPMethod, url: URL, headers: HTTPHeaders?, encoding: ParameterEncoding) -> Observable<T> {
        return Observable.create { observer in
           let request = AF.request(url,
                       method: method)
                .validate()
                .responseDecodable(of: type!.self) { response in
                    switch response.result {
                    case .success:
                        guard let data = response.data else { return }
                        do {
                            let decoder = JSONDecoder()
                            let object = try decoder.decode(type!.self, from: data)
                            observer.onNext(object)
                            observer.onCompleted()
                        } catch {
                            print("Couldn't decode data")
                        }
                    case .failure(let error):
                        self.handleRequestFailure(error, dataResponse: response, observer: observer)
                    }
                }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    private func handleRequestFailure<T: Codable>(_ error: AFError, dataResponse: DataResponse<T, AFError>, observer: AnyObserver<T>) {
        switch error {
        case .requestRetryFailed(let retryError, _):
            if (retryError as NSError).badNetworkError {
                observer.onError(SPAError.badNetworkConnection)
            } else if (retryError as NSError).networkError {
                observer.onError(SPAError.noInternetConnection)
            } else {
                observer.onError(SPAError.unacceptableStatusCode(code: 401))
            }
        case .sessionTaskFailed(let taskedFailedError):
            if(taskedFailedError as NSError).badNetworkError {
                observer.onError(SPAError.noInternetConnection)
            } else {
                observer.onError(error)
            }
        case .responseValidationFailed(let reason):
            switch reason {
            case .unacceptableStatusCode(let code):
                handleUnacceptableStatusCode(Int32(code), dataResposne: dataResponse, observer: observer)
            default:
                observer.onError(error)
            }
        default:
            observer.onError(error)
        }
    }
    
    private func handleUnacceptableStatusCode<T: Codable>(_ code: Int32, dataResposne: DataResponse<T, AFError>, observer: AnyObserver<T>) {
        switch code {
        case 401:
            observer.onError(SPAError.unknownAPIKey)
        case 403:
            observer.onError(SPAError.apiKeyNotCleared)
        case 500:
            observer.onError(SPAError.internalServerError)
        default:
            observer.onError(SPAError.unacceptableStatusCode(code: code))
        }
    }
}

enum SPAError: Error {
    case unknownAPIKey, apiKeyNotCleared, internalServerError, noInternetConnection, badNetworkConnection, unacceptableStatusCode(code: OSStatus)
}

extension NSError {
    var networkError: Bool {
        code == URLError.notConnectedToInternet.rawValue
        || code == URLError.dataNotAllowed.rawValue
    }
    
    var badNetworkError: Bool {
        code == URLError.networkConnectionLost.rawValue
        || code == URLError.cannotFindHost.rawValue
        || code == URLError.timedOut.rawValue
    }
}
