//
//  ViewController.swift
//  peerSend
//
//  Created by Ryan Resnick on 11/14/18.
//  Copyright © 2018 ghost. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let c = ColorService()
    
    
    
    
    @IBOutlet weak var peersLabel: UILabel!
    
    

    @IBAction func searchPeers(_ sender: Any) {
        
        peersLabel.text = String (c.session.connectedPeers[0].displayName)
        
        
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

