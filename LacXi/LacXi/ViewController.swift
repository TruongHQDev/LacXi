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
    
    @IBOutlet weak var vwCapture: UIView!
    @IBOutlet weak var vwBack: UIView!
    @IBOutlet weak var vwShare: UIView!
    
    var minimum = 0
    var maximum = 0
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
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            if isShaking { return }
            print("start")
            let temp = self.runRandom(minimum: minimum, maximum: maximum, type: type)
            DispatchQueue.main.asyncAfter(deadline: .now() + addTime(num: 5)) { // Change `2.0` to the desired number of seconds.
                self.isShaking = false
                
                print("value: \(temp)")
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
        isShaking = false
        
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
}
