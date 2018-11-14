//
//  PictureService.swift
//  peerSend
//
//  Created by Ryan Resnick & Miles Yohai on 11/14/18.
//  Copyright © 2018 ghost. All rights reserved.
//

import Foundation
import MultipeerConnectivity


class PictureService : NSObject {
    
    static let PictureServiceType = "example-picture"
    
    private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    private let serviceAdvertiser : MCNearbyServiceAdvertiser
    //private let serviceBrowser : MCNearbyServiceBrowser
    
    var delegate : PictureServiceDelegate?
    
    // session
    lazy var session : MCSession = {
        let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        return session
    }()
    
    func send(pictureName : String) {
        NSLog("%@", "sendPicture : \(pictureName) to \(session.connectedPeers.count) peers")
        
        if session.connectedPeers.count > 0 {
            do {
                try self.session.send(pictureName.data(using: .utf8)!, toPeers: session.connectedPeers, with: .reliable)
            }
            catch let error {
                NSLog("%@", "Error for sending: \(error)")
            }
        }
    }
    
    
    override init() {
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: PictureService.PictureServiceType)
        //self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: PictureServiceType)
        super.init()
        self.serviceAdvertiser.delegate = self
        self.serviceAdvertiser.startAdvertisingPeer()
        
        //self.serviceBrowser.delegate = self
        //self.serviceBrowser.startBrowsingForPeers()
    }
    
    deinit {
        self.serviceAdvertiser.stopAdvertisingPeer()
        // self.serviceBrowser.stopBrowsingForPeers()
    }
    
}

// Protocol for service delegate
protocol PictureServiceDelegate {
    
    func connectedDevicesChanged(manager : PictureService, connectedDevices: [String])
    func colorChanged(manager : PictureService, colorString: String)
    
}


// Session delegate
extension PictureService : MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        NSLog("%@", "peer \(peerID) didChangeState: \(state.rawValue)")
        self.delegate?.connectedDevicesChanged(manager: self, connectedDevices: session.connectedPeers.map{$0.displayName})
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveData: \(data)")
        let str = String(data: data, encoding: .utf8)!
        self.delegate?.colorChanged(manager: self, colorString: str)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveStream")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        NSLog("%@", "didStartReceivingResourceWithName")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        NSLog("%@", "didFinishReceivingResourceWithName")
    }
    
}

// extension for advertiser delegate functions
extension PictureService : MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        NSLog("%@", "didReceiveInvitationFromPeer \(peerID)")
        invitationHandler(true, self.session)
    }
    
}

// extension for browser
/*
 extension PictureService : MCNearbyServiceBrowserDelegate {
 
 func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
 NSLog("%@", "didNotStartBrowsingForPeers: \(error)")
 }
 
 func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
 NSLog("%@", "foundPeer: \(peerID)")
 NSLog("%@", "invitePeer: \(peerID)")
 browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 10)
 }
 
 func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
 NSLog("%@", "lostPeer: \(peerID)")
 }
 
 
 }
 */
