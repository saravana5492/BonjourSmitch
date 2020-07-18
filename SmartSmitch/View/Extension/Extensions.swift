//
//  Extensions.swift
//  SmartSmitch
//
//  Created by Saravanan B on 18/07/20.
//  Copyright © 2020 iSaravana. All rights reserved.
//

import Foundation
import UIKit

//MARK:- NetService : Get ip address from netservice address
extension NetService {
    func fetchIPv4address() -> String? {
        var result: String?
        if let addresses = self.addresses, addresses.count > 0 {
            for addr in addresses {
                let data = addr as NSData
                var storage = sockaddr_storage()
                data.getBytes(&storage, length: MemoryLayout<sockaddr_storage>.size)

                if Int32(storage.ss_family) == AF_INET {
                    let addr4 = withUnsafePointer(to: &storage) {
                        $0.withMemoryRebound(to: sockaddr_in.self, capacity: 1) {
                            $0.pointee
                        }
                    }
                    if let ip = String(cString: inet_ntoa(addr4.sin_addr), encoding: .ascii), ip != "127.0.0.1" {
                        result = ip
                        break
                    }
                }
            }
        }
        return result
    }
}


//MARK:- UIButtun animation
extension UIButton {
    
    //MARK: Button pulse effect
    func fadeAnimate() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.1
        flash.fromValue = 1
        flash.toValue = 0.5
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 1

        layer.add(flash, forKey: nil)
    }
}
