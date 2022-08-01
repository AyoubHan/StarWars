//
//  SessionRepo.swift
//  StarWarsHilde
//
//  Created by Hanine-EXT, Ayoub (uif25188) on 21/07/2022.
//

import Foundation
import RxSwift

protocol SessionRepositoryProtocol {
    func openSession() -> Observable<SW>
}

class SessionRepository: SessionRepositoryProtocol {
    private(set) var dataProvider: SessionDataProvider = SPASessionDataProvider()
    
    func openSession() -> Observable<SW> {
        dataProvider.openSession()
    }
}
