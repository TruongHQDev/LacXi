//
//  ViewController.swift
//  LacXi
//
//  Created by AUTO SERVER on 29/01/2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var vwToSetting: UIView!
    
    @IBOutlet weak var vwReset: UIView!
    @IBOutlet weak var btnReset: UIButton!
    
    @IBOutlet weak var vwCenter: UIView!
    
    @IBOutlet weak var vwCongrat: UIView!
    @IBOutlet weak var vwLbCongrat: UIView!
    @IBOutlet weak var vwSelfieImage: UIView!
    @IBOutlet weak var vwMoneyResultt: UIView!
    @IBOutlet weak var lbCongratTop: UILabel!
    @IBOutlet weak var lbCongratBot: UILabel!
    
    @IBOutlet weak var vwCapture: UIView!
    @IBOutlet weak var vwBack: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var vwShare: UIView!
    
    var minimum = 0
    var maximum = 4
    var type: RandomType = .even
    var isShaking = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            if isShaking { return }
            print("start")
            let temp = self.runRandom(minimum: minimum, maximum: maximum, type: type)
            DispatchQueue.main.asyncAfter(deadline: .now() + addTime(num: 5)) { // Change `2.0` to the desired number of seconds.
                
                let strTop = "CHÚC MỪNG!!!"
                let strBot = "Bạn đã nhận được\n\(temp)đ\nTừ Quang Trường"
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
    
    func addTime(num: Int) -> Double {
        return 0.0
    }
    
    func resetToShake() {
        hideCongrat()
        //reset layout
        
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
    }
    
    func showCongrat() {
        vwCongrat.alpha = 1
        isShaking = true
    }
}
