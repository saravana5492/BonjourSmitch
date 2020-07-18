//
//  ViewController.swift
//  SmartSmitch
//
//  Created by Saravanan B on 16/07/20.
//  Copyright © 2020 iSaravana. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var publishButton: UIButton!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var infoLabel: UILabel!
    
    //MARK:- Variables
    var services = [FormattedService]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ScannedServiceCell", bundle: nil), forCellReuseIdentifier: "ScannedServiceCell")
        setupUI()
    }
    
    //MARK: Setup the UI
    private func setupUI() {
        PublishServiceHandler.shared.delegate = self
        ScanNetworkHandler.shared.delegate = self

        publishButton.layer.cornerRadius = 5.0
        scanButton.layer.cornerRadius = 5.0
        
        showLabels(withText: "Tap on PUBLISH to share your Net services")
    }
    
    //MARK: Publish Button Action
    @IBAction func publishDidPress() {
        publishButton.fadeAnimate()
        PublishServiceHandler.shared.publishService()
    }
    
    //MARK: Scan Button Action
    @IBAction func scanDidPress() {
        scanButton.fadeAnimate()
        ScanNetworkHandler.shared.scanServices()
    }
    
    //MARK: Show instruction label
    private func showLabels(withText text: String) {
        tableView.isHidden = true
        infoLabel.isHidden = false
        infoLabel.text = text
    }
    
    //MARK: Reload services table view
    private func reloadServicesTable() {
        if self.services.count > 0 {
            tableView.isHidden = false
            infoLabel.isHidden = true
            infoLabel.text = ""
            tableView.reloadData()
        }
    }
}

//MARK:- PublishServiceDelegate, ScanNetworkDelegate methods
extension ViewController: PublishServiceDelegate, ScanNetworkDelegate {
    func serviceDidPublishSuccess(withNetService netService: NetService) {
        showLabels(withText: "\(netService.name)'s network service has been published successfully..!\n\nTap on SCAN to see all the published networks")
    }
    
    func serviceDidFailToPublish() {
        showLabels(withText: "Sorry!, There is some error in publishing")
    }
    
    func didServicesScanned(withServices netServices: [FormattedService]) {
        self.services.removeAll()
        self.services = netServices
        if self.services.count > 0 {
            reloadServicesTable()
        } else {
            showLabels(withText: "There is no publised net services")
        }
    }
    
    func didFailedToScanServices() {
        if services.count > 0 {
            reloadServicesTable()
        } else {
            showLabels(withText: "There is no publised net services")
        }
    }
}

//MARK:- UITableViewDelegate, UITableViewDataSource methods
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ScannedServiceCell", for: indexPath) as? ScannedServiceCell {
            cell.serviceNameLabel.text = "Name: \(services[indexPath.row].name)"
            cell.serviceDetailsLabel.text = "IP Address: \(services[indexPath.row].ipAddress)\nDomain: \(services[indexPath.row].domain)\nType: \(services[indexPath.row].type)\nPort: \(services[indexPath.row].port)"
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
