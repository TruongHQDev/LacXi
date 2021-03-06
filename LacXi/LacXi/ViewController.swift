//
//  ViewController.swift
//  LacXi
//
//  Created by AUTO SERVER on 29/01/2021.
//

import UIKit
import AVFoundation
import Lottie

class ViewController: UIViewController {
    @IBOutlet weak var vwToSetting: UIView!
    
    @IBOutlet weak var vwReset: UIView!
    @IBOutlet weak var btnReset: UIButton!
    
    @IBOutlet weak var vwCenter: UIView!
    
    @IBOutlet weak var vwCongrat: UIView!
    @IBOutlet weak var vwLbCongrat: UIView!
    @IBOutlet weak var vwSelfieImage: UIView!
    @IBOutlet weak var imgSelfie: UIImageView!
    
    @IBOutlet weak var vwMoneyResultt: UIView!
    @IBOutlet weak var lbCongratTop: UILabel!
    @IBOutlet weak var lbCongratBot: UILabel!
    
    @IBOutlet weak var vwCapture: UIView!
    @IBOutlet weak var btnCapture: UIButton!
    
    @IBOutlet weak var vwBgCongrat: UIView!
    @IBOutlet weak var imgBgCongrat: UIImageView!
    @IBOutlet weak var vwBack: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var vwShare: UIView!
    
    var minimum = 0
    var maximum = 4
    var type: RandomType = .even
    var isShaking = false
    var isCaptured = false
    
    var captureSession = AVCaptureSession()
    var backCamera:      AVCaptureDevice?
    var frontCamera:     AVCaptureDevice?
    var currentCamera:   AVCaptureDevice?
    
    var photoOutput:     AVCapturePhotoOutput?
    var cameraPreviewPlayer: AVCaptureVideoPreviewLayer?
    var image: UIImage?
    var animationView: AnimationView?
    
    var coinDropSound: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewPlayer()
    }
    
    @IBAction func resetTapped(_ sender: Any) {
        resetToShake()
    }
    
    @IBAction func settingTapped(_ sender: Any) {
        _ = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
        controller.settingDelegate = self
        
        self.present(controller, animated: true, completion: nil)
        
    }
    
    @IBAction func backTapped(_ sender: Any) {
        resetToShake()
    }
    
    @IBAction func captureTapped(_ sender: Any) {
        if isCaptured {
            imgSelfie.image = UIImage(named: "")
            isCaptured = false
            vwSelfieImage.isHidden = false
            startRunningCaptureSession()
            
        } else {
            let settings = AVCapturePhotoSettings()
            photoOutput?.capturePhoto(with: settings, delegate: self)
            
        }
        
    }
    
    @IBAction func shareTapped(_ sender: Any) {
        vwBack.alpha = 0
        vwCapture.alpha = 0
        vwShare.alpha = 0
        let secs = 0.1
        DispatchQueue.main.asyncAfter(deadline: .now() + secs) {
            let image = UIImage.init(view: self.view)
            
            let share = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            self.present(share, animated: true) {
                self.vwBack.alpha = 1
                self.vwCapture.alpha = 1
                self.vwShare.alpha = 1
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        animationView?.play()
        startRunningCaptureSession()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animationView?.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopRunningCaptureSession()
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            if isShaking { return }
//            print("start")
            isShaking = true
            let temp = self.runRandom(minimum: minimum, maximum: maximum, type: type)
            DispatchQueue.main.asyncAfter(deadline: .now() + addTime(num: Double.random(in: 2...7) )) { // Change `2.0` to the desired number of seconds.
                
                let path = Bundle.main.path(forResource: "coinDrop.mp3", ofType:nil)!
                let url = URL(fileURLWithPath: path)

                do {
                    self.coinDropSound = try AVAudioPlayer(contentsOf: url)
                    self.coinDropSound?.play()
                } catch {
                    // couldn't load file :(
                }
                
                let strTop = "CHÚC MỪNG!!!"
                let strBot = "Bạn đã nhận được\n\(temp)đ\ntừ Quang Trường"
                self.lbCongratTop.text = strTop
                self.lbCongratBot.text = strBot
                self.showCongrat()
            }
        }
    }
    
    func runRandom(minimum: Int, maximum: Int, type: RandomType?) -> Int {
        var isEven = false
        switch type {
        case .even:
            isEven = true
        case .odd:
            isEven = false
        default:
            break
        }
        let num = Int.random(in: minimum...(isEven ? maximum : maximum*10))
//        let num = Int(arc4random())
        return isEven ? num*10000 : num*1000
    }
    
    func addTime(num: Double) -> Double {
        return num
    }
    
    func resetToShake() {
        hideCongrat()
        //reset layout
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent // .default
    }
}

extension ViewController: SettingDelegate {
    func saveData(min: Int, max: Int, typeRandom: RandomType?) {
        minimum = min
        maximum = max
        type = typeRandom ?? .even
        
        //reset
        resetToShake()
    }
    
    func hideCongrat() {
        vwCongrat.alpha = 0
        lbCongratBot.text = ""
        lbCongratTop.text = ""
        isShaking = false
        isCaptured = false
        imgSelfie.image = UIImage(named: "")
        
        
    }
    
    func showCongrat() {
        vwCongrat.alpha = 1
        isShaking = true
        vwSelfieImage.isHidden = false
        startRunningCaptureSession()
    }
}

extension ViewController {
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
        
        currentCamera = frontCamera
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
    
    func setupPreviewPlayer() {
        cameraPreviewPlayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewPlayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewPlayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewPlayer?.frame = vwSelfieImage.bounds
        self.vwSelfieImage.layer.insertSublayer(cameraPreviewPlayer!, at: 0)
    }
    
    func startRunningCaptureSession() {
        captureSession.startRunning()
    }
    
    func stopRunningCaptureSession() {
        captureSession.stopRunning()
    }
    
    func hidePreviewLayer() {
        vwSelfieImage.layer.isHidden = true
    }
    
    func setupLayout() {
        vwSelfieImage.layer.cornerRadius = vwSelfieImage.frame.size.height / 2
        imgSelfie.frame = vwSelfieImage.frame
        imgSelfie.layer.cornerRadius = imgSelfie.frame.size.height / 2
        
        animationView = .init(name: "box")
        animationView?.frame = vwCenter.bounds
        animationView?.loopMode = .loop
        animationView?.animationSpeed = 1
//        view.addSubview(animationView!)
//        view.bringSubviewToFront(animationView!)
        vwCenter.addSubview(animationView!)
        animationView?.play()
//        animationView?.pause()
//        vwCenter.bringSubviewToFront(animationView!)
    }
}

extension ViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        stopRunningCaptureSession()
        if let imageData = photo.fileDataRepresentation() {
            if currentCamera!.position == AVCaptureDevice.Position.front {
//                let img = UIImage(cgImage: <#T##CGImage#>, scale: <#T##CGFloat#>, orientation: <#T##UIImage.Orientation#>)
                image = UIImage(data: imageData)
//                image = UIImage(cgImage: , scale: UIScreen.main.scale, orientation: .leftMirrored)
//                image?.imageOrientation.rawValue
            } else {
                image = UIImage(data: imageData)
            }
            
            isCaptured = true
            DispatchQueue.main.async {
                self.imgSelfie.image = self.image
                self.vwSelfieImage.isHidden = true
            }
        }
    }
}

extension UIImage{
    convenience init(view: UIView) {

    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
    view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    self.init(cgImage: (image?.cgImage)!)

  }
}
