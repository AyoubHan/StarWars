//
//  SPAccess.swift
//  StarWars
//
//  Created by Hanine-EXT, Ayoub (uif25188) on 21/07/2022.
//

import Foundation

class SPAccess {
    
    static let shared: SPAccess = {
        let instance = SPAccess()
        return instance
    }()
    
    private var accessManager: AccessManager
    
    init(accessManager: AccessManager = AccessManager()) {
        self.accessManager = accessManager
    }
    
    func openSession() {
        accessManager.sessionManager.openSession()
        
    }
}
