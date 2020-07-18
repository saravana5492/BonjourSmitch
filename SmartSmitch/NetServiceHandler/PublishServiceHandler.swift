//
//  PublishServiceHandler.swift
//  SmartSmitch
//
//  Created by Saravanan B on 16/07/20.
//  Copyright © 2020 iSaravana. All rights reserved.
//

import Foundation
import UIKit

//MARK:- Delegate for Publish servie success and failure
protocol PublishServiceDelegate {
    func serviceDidPublishSuccess(withNetService netService: NetService)
    func serviceDidFailToPublish()
}

//MARK:- Handle the network publish
class PublishServiceHandler: NSObject {
    //MARK: Signleton
    static let shared = PublishServiceHandler()
    
    //MARK: Variables
    var netService = NetService()
    var delegate: PublishServiceDelegate?
    
    //MARK: Publish service functionality
    func publishService() {
        netService = NetService(domain: "local.", type: "_http._tcp", name: "Smitch - \(UIDevice.current.name)", port: 80)
        netService.delegate = self
        netService.publish()
    }
}

//MARK:- NetServiceDelegate methods
extension PublishServiceHandler: NetServiceDelegate {
    
    func netServiceDidPublish(_ sender: NetService) {
        delegate?.serviceDidPublishSuccess(withNetService: sender)
    }
    
    func netService(_ sender: NetService, didNotPublish errorDict: [String : NSNumber]) {
        delegate?.serviceDidFailToPublish()
    }
}
