//
//  Enums.swift
//  LacXi
//
//  Created by AUTO SERVER on 02/02/2021.
//

import Foundation
import UIKit

enum RandomType {
    case even
    case odd
}



protocol SettingDelegate {
    func saveData(min: Int, max: Int, typeRandom: RandomType?)
}
