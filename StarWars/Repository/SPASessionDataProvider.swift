//
//  SPASessionDataProvider.swift
//  StarWarsHilde
//
//  Created by Hanine-EXT, Ayoub (uif25188) on 21/07/2022.
//

import Foundation
import Alamofire
import RxSwift

protocol SessionDataProvider {
    func openSession() -> Observable<SW>
}

class SPASessionDataProvider: SessionDataProvider {
    let disposeBag = DisposeBag()
    func components() -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "swapi.dev"
        components.path = "/api/starshipss"
        return components
    }
    
    func getURL() -> URL {
        let components = components()
        let url = components.url ?? URL(fileURLWithPath: "")
        return url
    }
    
    func openSession() -> Observable<SW> {
        DataProviderManager.shared.makeRequest(type: SW.self, method: .get, url: getURL(), encoding: JSONEncoding.default)
    }
}
