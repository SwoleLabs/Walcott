//
//  WatchDelegate.swift
//  Walcott
//
//  Created by David Barsky on 10/21/15.
//  Copyright © 2015 David Barsky. All rights reserved.
//

import WatchConnectivity

// MARK: - Initialization
class WatchSessionManager: NSObject, WCSessionDelegate {
    static let sharedManager = WatchSessionManager()
    private override init() {
        super.init()
    }
    
    // keeping a reference for the session, used later to send/recieve data.
    private let session: WCSession? = WCSession.isSupported() ? WCSession.defaultSession() : nil
    
    private var validSession: WCSession? {
        
        // paired - the user has to have their device paired to the watch
        // watchAppInstalled - the user must have your watch app installed
        
        // Note: if the device is paired, but your watch app is not installed
        // consider prompting the user to install it for a better experience
        
        if let session = session where session.paired && session.watchAppInstalled {
            return session
        } else {
            return nil
        }
    }

    func startSession() {
        session?.delegate = self
        session?.activateSession()
    }
}

// MARK: - Interactive Messaging
extension WatchSessionManager {
    private var validReachableSession: WCSession? {
        // check for validSession on iOS only (see above) in Watch App, you can just do an if session.reachable check
        if let session = validSession where session.reachable {
            return session
        }
        return nil
    }
}