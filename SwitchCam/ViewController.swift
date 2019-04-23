//
//  ViewController.swift
//  SwitchCam
//
//  Created by Aleksandr Bydaiev on 4/19/19.
//  Copyright © 2019 ab.name. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var cameraVC:CameraViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cameraVC = CameraViewController.instantiate()
    }
    
    private func checkAccessToCamera() {
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            
        case .notDetermined:
            
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    
                    print("granted")
                    
                    self.navigationController?.pushViewController(self.cameraVC!,
                                                                  animated: true,
                                                                  completion: {
                                                                    
                                                                    self.cameraVC!.setupCamera()
                    })
                    
                } else {
                    
                    print("denied")
                }
            }
            
        case .denied:
            
            print("denied")
            break
            
        case .restricted:
            
            print("restricted")
            break
            
        case .authorized:
            
            self.navigationController?.pushViewController(self.cameraVC!,
                                                          animated: true,
                                                          completion: {
                                                            
                                                            self.cameraVC!.setupCamera()
            })
            
        @unknown default:
            break
        }
    }
    
    @IBAction func toCamera(_ sender: Any) {
        
        self.checkAccessToCamera()
    }
}

extension UINavigationController {
    
    public func pushViewController(_ viewController: UIViewController,
                                   animated: Bool,
                                   completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
}
