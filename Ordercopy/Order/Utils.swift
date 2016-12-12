//
//  Utils.swift
//  Order
//
//  Created by John De Guzman on 2016-12-12.
//  Copyright © 2016 John De Guzman. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class func colorFromRGB(_ rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
