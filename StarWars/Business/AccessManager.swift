//
//  AccessManager.swift
//  StarWars
//
//  Created by Hanine-EXT, Ayoub (uif25188) on 21/07/2022.
//

import Foundation

class AccessManager {
    
    var sessionManager: SessionManagerProtocol
    
    init(sessionManager: SessionManagerProtocol = SessionManager()) {
        self.sessionManager = sessionManager
    }
}
