//
//  ScannedServiceCell.swift
//  SmartSmitch
//
//  Created by Saravanan B on 17/07/20.
//  Copyright © 2020 iSaravana. All rights reserved.
//

import UIKit

class ScannedServiceCell: UITableViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var serviceNameLabel: UILabel!
    @IBOutlet weak var serviceDetailsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyShadowOnView(containerView)
    }

    //MARK:- Add shadow to the view
    func applyShadowOnView(_ view: UIView) {
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 4
    }
    
}
