//
//  SessionManager.swift
//  StarWars
//
//  Created by Hanine-EXT, Ayoub (uif25188) on 21/07/2022.
//

import Foundation
import RxSwift

protocol SessionManagerProtocol {
    func openSession()
}


class SessionManager: SessionManagerProtocol {
    
    var disposeBag = DisposeBag()
    var sessionRepository: SessionRepositoryProtocol
    
    init(sessionRepository: SessionRepositoryProtocol = SessionRepository()) {
        self.sessionRepository = sessionRepository
    }
    
    func openSession() {
        
        var starships: [String] = []
        
        sessionRepository.openSession()
            .subscribe { vehicles in
                for starship in vehicles.results {
                    starships.append(starship.name)
                }
            } onCompleted: {
                print(starships)
            }.disposed(by: disposeBag)
    }
}
