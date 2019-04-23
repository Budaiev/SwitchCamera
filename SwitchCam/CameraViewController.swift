//
//  CameraViewController.swift
//  SwitchCam
//
//  Created by Aleksandr Bydaiev on 4/19/19.
//  Copyright © 2019 ab.name. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    var camType:CameraType = .back
    
    var cameraObjC:Camera = Camera.create()
    
    @IBOutlet weak var previewView: UIView!
    
    @IBOutlet weak var photoPreviewImageView: UIImageView!
    
    var captureSession:     AVCaptureSession?
    var stillImageOutput:   AVCapturePhotoOutput?
    var videoPreviewLayer:  AVCaptureVideoPreviewLayer?
    
    
    /// Init through UIStoryboard.
    public static func instantiate() -> CameraViewController {
        
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        setupSession()
        cameraObjC.setupSession()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        captureSession!.stopRunning()
        cameraObjC.stopRun()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    private func selectCamera(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        
        if let cameraDevice = AVCaptureDevice.DiscoverySession.init(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: .video, position: position).devices.first { //}.localizedName {
            
//            print("camera: \(cameraDevice.localizedName)") Back/Front Camera
            
            return cameraDevice
        }
        
        return nil
    }
    
    public func setupObjCCamera() {
        
        cameraObjC.setupCamera(withType: self.camType.rawValue, castTo: self.previewView)
    }
    
    public func setupCamera() {
        
        let camType = AVCaptureDevice.Position.init(rawValue: self.camType.rawValue)
        
        guard let backCamera = selectCamera(position:camType!)
            
            else {
                
                print("Unable to access back camera!")
                return
        }
        
        var error: NSError?
        var input: AVCaptureDeviceInput!
        
        do {
            
            input = try AVCaptureDeviceInput(device: backCamera)
            
        } catch let err as NSError {
            
            error = err
            input = nil
            
            print("Camera error: \(err.localizedDescription)")
        }
        
        if error == nil && captureSession!.canAddInput(input) {
            
            captureSession!.addInput(input)
            stillImageOutput = AVCapturePhotoOutput()
            
            setupLivePreview()
        } else {
            
            print("Unable to AddInput!")
        }
    }
    
    // MARK: <AVCapturePhotoCaptureDelegate>
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation()
            else { return }
        
        let image = UIImage(data: imageData)
        
        ///persist shot
        self.photoPreviewImageView.image = image
    }
    
    
    @IBAction func onTakePhoto(_ sender: Any) {
        
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        
//        stillImageOutput!.capturePhoto(with: settings, delegate: self)
        
        self.cameraObjC.stillImageOutput!.capturePhoto(with: settings, delegate: self)
    }
    
    
    @IBAction func onSwitchCamera(_ sender: Any) {
        
//        captureSession!.stopRunning()
        cameraObjC.stopRun()
        
        self.camType.toggle()
        
//        setupSession()
        cameraObjC.setupSession()
        
        UIView.transition(with: previewView,
                          duration: 0.25,
                          options: [.transitionFlipFromRight],
                          animations: {
                            
                            self.cameraObjC.setupCamera(withType: self.camType.rawValue, castTo: self.previewView)
                            //self.setupCamera()
                            
        }, completion: nil)
    }
    
    func setupSession() {
        
        self.captureSession = AVCaptureSession()
        self.captureSession!.sessionPreset = AVCaptureSession.Preset.medium
    }
    
    func setupLivePreview() {
        
        if captureSession!.canAddOutput(stillImageOutput!) {
            
            captureSession!.addOutput(stillImageOutput!)
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer!.videoGravity = AVLayerVideoGravity.resizeAspect
            videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
            videoPreviewLayer!.frame = previewView.bounds
            self.previewView.layer.addSublayer(videoPreviewLayer!)
            
            captureSession!.startRunning()
        }
        
    }
    
}


protocol Togglable {
    
    mutating func toggle()
}

enum CameraType: Int, Togglable {
    
    case back = 1, front
    
    mutating func toggle() {
        
        switch self {
        
        case .back:
            self = .front
        
        case .front:
            self = .back
        }
        
    }
}
