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
    
    @IBOutlet weak var vwTypeRandom: UIView!
    @IBOutlet weak var segmentTypeRandom: UISegmentedControl!
    
    @IBOutlet weak var vwSave: UIView!
    @IBOutlet weak var btnSave: UIButton!
    
    var settingDelegate: SettingDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func segmentChange(_ sender: Any) {
        
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        
    }
    
}
