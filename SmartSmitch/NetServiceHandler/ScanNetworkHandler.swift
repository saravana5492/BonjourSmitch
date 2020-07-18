//
//  ScanNetworkHandler.swift
//  SmartSmitch
//
//  Created by Saravanan B on 16/07/20.
//  Copyright © 2020 iSaravana. All rights reserved.
//

import Foundation
import UIKit

//MARK:- Delegate for Publish servie Scan Netservice success and failure
protocol ScanNetworkDelegate {
    func didServicesScanned(withServices netServices: [FormattedService])
    func didFailedToScanServices()
}

class ScanNetworkHandler: NSObject {
    //MARK: Signleton
    static let shared = ScanNetworkHandler()
    
    //MARK: Variables
    private lazy var serviceBrowser = NetServiceBrowser()
    var delegate: ScanNetworkDelegate?
    var services = [NetService]() {
        didSet {
            formatServices()
        }
    }
    var scannedServices = [FormattedService]()
    
    //MARK: Publish service functionality
    func scanServices() {
        serviceBrowser.delegate = self
        serviceBrowser.searchForServices(ofType: "_http._tcp", inDomain: "local.")
    }
    
    //MARK: Check and resolve the fetched services
    func resolveService () {
        for service in self.services {
            if service.port == -1 {
                service.delegate = self
                service.resolve(withTimeout:10)
            }
        }
    }
    
    //MARK: Format services to display
    func formatServices() {
        scannedServices.removeAll()
        for service in self.services {
            let scannedService = FormattedService(name: service.name, type: service.type, domain: service.domain, ipAddress: service.fetchIPv4address() ?? "IP address not found", port: "\(service.port)")
             self.scannedServices.append(scannedService)
        }
        if scannedServices.count > 0 {
            delegate?.didServicesScanned(withServices: scannedServices)
        }
    }
    
    //MARK: Add resolved service in the services array
    func addResolvedNetservice(_ netService: NetService) {
        if let serviceIndex = self.services.firstIndex(of: netService) {
            self.services.remove(at: serviceIndex)
            self.services.insert(netService, at: serviceIndex)
        }
    }
}

//MARK:- NetServiceBrowserDelegate, NetServiceDelegate methods
extension ScanNetworkHandler: NetServiceBrowserDelegate, NetServiceDelegate {
    func netServiceDidResolveAddress(_ sender: NetService) {
        addResolvedNetservice(sender)
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didNotSearch errorDict: [String : NSNumber]) {
        print("Error searching for service")
        delegate?.didFailedToScanServices()
    }

    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        services.append(service)
        if !moreComing {
            self.resolveService()
        }
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didRemove service: NetService, moreComing: Bool) {
        if let serviceIndex = self.services.firstIndex(of: service) {
            self.services.remove(at: serviceIndex)
        }
    }
}

//MARK:- Model for scanned services
struct FormattedService {
    var name: String = ""
    var type: String = ""
    var domain: String = ""
    var ipAddress: String = ""
    var port: String = ""
    
    init(name: String, type: String, domain: String, ipAddress: String, port: String) {
        self.name = name
        self.type = type
        self.domain = domain
        self.ipAddress = ipAddress
        self.port = port
    }
}
