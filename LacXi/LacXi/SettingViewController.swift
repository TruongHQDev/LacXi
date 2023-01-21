//
//  SettingViewController.swift
//  LacXi
//
//  Created by AUTO SERVER on 01/02/2021.
//

import UIKit

class SettingViewController: UIViewController {
    @IBOutlet weak var vwTop: UIView!
    @IBOutlet weak var vwCenter: UIView!
    
    @IBOutlet weak var vwMinimumSetting: UIView!
    @IBOutlet weak var txtMinimum: UITextField!
    
    @IBOutlet weak var vwMaximumSetting: UIView!
    @IBOutlet weak var txtMaximum: UITextField!
    
    @IBOutlet weak var vwCongratTitle: UIView!
    @IBOutlet weak var lbDescriptionCongrat: UILabel!
    
    @IBOutlet weak var vwTypeRandom: UIView!
    @IBOutlet weak var segmentTypeRandom: UISegmentedControl!
    
    @IBOutlet weak var vwSave: UIView!
    @IBOutlet weak var btnSave: UIButton!
    
    var settingDelegate: SettingDelegate?
    var minimum = 0
    var maximum = 0
    var type:RandomType = .even
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyBoardWhenTappedAround()
        txtMinimum.keyboardType = .numberPad
        txtMaximum.keyboardType = .numberPad
    }
    
    @IBAction func segmentChange(_ sender: Any) {
        switch segmentTypeRandom.selectedSegmentIndex {
        case 0:
            type = .even
        case 1:
            type = .odd
        default:
            break
        }
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        let min = Int(txtMinimum.text ?? "0")
        let max = Int(txtMaximum.text ?? "0")
        let typeRandom = type
        
        settingDelegate?.saveData(min: min ?? 0, max: max ?? 0, typeRandom: typeRandom)
        self.dismiss(animated: true, completion: nil)
    }
    
}
