//
//  SingleTon.swift
//  LacXi
//
//  Created by AUTO SERVER on 02/02/2021.
//

import Foundation
import UIKit

class SingleTonModel {
    struct Static {
        fileprivate static var instance: SingleTonModel?
    }

    class var shared: SingleTonModel {
        if Static.instance == nil
        {
            Static.instance = SingleTonModel()
        }

        return Static.instance!
    }

    func dispose()
    {
        SingleTonModel.Static.instance = nil
    }

    deinit {
        print(" View Model Deinit: \(self)")
    }
    
    var minimumValue = 0
    var maximumValue = 0
    var type: RandomType = .even
    
}


