//
//  CameraViewController.swift
//  LacXi
//
//  Created by Trường  on 1/14/23.
//

import UIKit
import AVFoundation

protocol CameraViewControllerDelegate: AnyObject {
    func sendImage(image: UIImage)
}


class CameraViewController: UIViewController {
    @IBOutlet weak var vwCamera: UIView!
    @IBOutlet weak var vwImageCapture: UIView!
    @IBOutlet weak var imgLibrary: UIImageView!
    @IBOutlet weak var imgReverseCamera: UIImageView!
    @IBOutlet weak var imgSelfie: UIImageView!
    
    //Delegate
    weak var delegate: CameraViewControllerDelegate?
    
    //Camera and Photo Variables
    var captureSession = AVCaptureSession()
    var backCamera:      AVCaptureDevice?
    var frontCamera:     AVCaptureDevice?
    var currentCamera:   AVCaptureDevice?
    var photoOutput:     AVCapturePhotoOutput?
    var cameraPreviewPlayer: AVCaptureVideoPreviewLayer?
    var image: UIImage?
    var isBackCamera: Bool = false {
        didSet {
            if isBackCamera {
                currentCamera = backCamera
            } else {
                currentCamera = frontCamera
            }
        }
    }
    
    
    //Support variables
    var isCaptured = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewPlayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startRunningCaptureSession()
    }
    
    private func setupLayout() {
        self.vwImageCapture.backgroundColor = UIColor.white
        self.vwImageCapture.layer.cornerRadius = self.vwImageCapture.bounds.width / 2
        self.vwImageCapture.layer.borderWidth = 3.0
        self.vwImageCapture.layer.borderColor = UIColor.gray.cgColor
    }
    
    func setupPreviewPlayer() {
        cameraPreviewPlayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewPlayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewPlayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewPlayer?.frame = vwCamera.bounds
        self.vwCamera.layer.insertSublayer(cameraPreviewPlayer!, at: 0)
    }
    
    //MARK: -- Outlet Actions
    @IBAction func captureTapped(_ sender: Any) {
        if isCaptured {
            imgSelfie.image = UIImage(named: "")
            isCaptured = false
            vwCamera.isHidden = false
            startRunningCaptureSession()
        } else {
            let settings = AVCapturePhotoSettings()
            photoOutput?.capturePhoto(with: settings, delegate: self)
        }
    }
    
    @IBAction func openLibraryTapped(_ sender: Any) {
        
    }
    
    @IBAction func switchCameraTapped(_ sender: Any) {
        isBackCamera.toggle()
        do{
            captureSession.removeInput(captureSession.inputs.first!)
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            captureSession.addInput(captureDeviceInput)
        }catch{
            print(error.localizedDescription)
        }
    }
    
    @IBAction func closeCameraTapped(_ sender: Any) {
        if imgSelfie.isHidden == false { //Available Photo
            //Retake photo
            imgSelfie.image = UIImage(named: "")
            imgSelfie.isHidden = true
            isCaptured = false
            vwCamera.isHidden = false
            startRunningCaptureSession()
        } else {
            //Close view capture
            self.dismiss(animated: true)
        }
    }
    
    func startRunningCaptureSession() {
        captureSession.startRunning()
    }
    
    func stopRunningCaptureSession() {
        captureSession.stopRunning()
    }
    
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession.devices
        
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device
            } else if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
            }
        }
        
        isBackCamera = false

    }
    
    func setupInputOutput() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
            
        } catch {
            print(error)
        }
    }

}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        stopRunningCaptureSession()
        if let imageData = photo.fileDataRepresentation() {
            self.delegate?.sendImage(image: UIImage(data: imageData)!)
            self.dismiss(animated: true)
        }
    }
}
