//
//  ViewController.swift
//  peerSend
//
//  Created by Ryan Resnick on 11/14/18.
//  Copyright © 2018 ghost. All rights reserved.
//

//
//  ViewController.swift
//  peerSend
//
//  Created by Ryan Resnick on 11/14/18.
//  Copyright © 2018 ghost. All rights reserved.
//

import UIKit
import MultipeerConnectivity


class ViewController: UIViewController, MCBrowserViewControllerDelegate {
    
    let p = PictureService()
    
    var serviceBrowser : MCBrowserViewController!
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
            
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
        }
    }
    
    
    @IBAction func peerSearch(_ sender: Any) {
        
        startBrowsingForPeer()
        
        
    }
    
    
    
    
    
   
    func startBrowsingForPeer()  {
        serviceBrowser = MCBrowserViewController(serviceType: PictureService.PictureServiceType, session: p.session)
        
        serviceBrowser.delegate = self
        
        present(serviceBrowser, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    //test comment miles
}

