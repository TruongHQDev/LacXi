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
    @IBOutlet weak var imgSelfie: UIImageView!
    @IBOutlet weak var vwSelfieImage: UIView!
    @IBOutlet weak var btnOpenCamera: UIButton!
    
    @IBOutlet weak var vwMoneyResultt: UIView!
    @IBOutlet weak var lbCongratTop: UILabel!
    @IBOutlet weak var lbCongratBot: UILabel!
    
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
    var animationView: AnimationView?
    
    var coinDropSound: AVAudioPlayer?
    var isCapturedImage = false {
        didSet {
            if isCapturedImage {
                self.btnOpenCamera.setImage(nil, for: .normal)
            } else {
                self.btnOpenCamera.setImage(UIImage(named: "iconLibraryDefault"), for: .normal)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
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
    
    @IBAction func openCameraTapped(_ sender: Any) {
        //Show CameraController
        _ = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard?.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
        controller.modalPresentationStyle = .overCurrentContext
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
        
    }
    
    @IBAction func shareTapped(_ sender: Any) {
        vwBack.alpha = 0
        vwShare.alpha = 0
        let secs = 0.1
        DispatchQueue.main.asyncAfter(deadline: .now() + secs) {
            let image = UIImage.init(view: self.view)
            
            let share = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            self.present(share, animated: true) {
                self.vwBack.alpha = 1
                self.vwShare.alpha = 1
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        animationView?.play()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animationView?.play()
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            if isShaking { return }
            isShaking = true
            let moneyValue = self.runRandom(minimum: minimum, maximum: maximum, type: type)
            DispatchQueue.main.asyncAfter(deadline: .now() + addTime(num: Double.random(in: 2...7) )) { // Change `2.0` to the desired number of seconds.
                
                let path = Bundle.main.path(forResource: "coinDrop.mp3", ofType:nil)!
                let url = URL(fileURLWithPath: path)

                do {
                    self.coinDropSound = try AVAudioPlayer(contentsOf: url)
                    self.coinDropSound?.play()
                } catch {
                    // couldn't load file :(
                }
                
                let strBot = "Bạn đã nhận được\n\(self.convertCurrency(money: Double(moneyValue)))đ\ntừ Quang Trường"
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
    
    func convertCurrency(money: Double) -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .decimal
        // localize to your grouping and decimal separator
        currencyFormatter.locale = Locale.current

        // We'll force unwrap with the !, if you've got defined data you may need more error checking
        let priceString = currencyFormatter.string(from: NSNumber(value: money))!
        return priceString
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
        imgSelfie.image = nil
    }
    
    func showCongrat() {
        vwCongrat.alpha = 1
        isShaking = true
        isCapturedImage = false
    }
}

extension ViewController {
    func setupLayout() {
        imgSelfie.layer.cornerRadius = imgSelfie.frame.size.height / 2
        //Box Animation
        animationView = .init(name: "box")
        animationView?.frame = vwCenter.bounds
        animationView?.loopMode = .loop
        animationView?.animationSpeed = 1
        vwCenter.addSubview(animationView!)
        animationView?.play()
    }
}

extension ViewController: CameraViewControllerDelegate {
    func sendImage(image: UIImage) {
        self.imgSelfie.image = image
        isCapturedImage = true
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
