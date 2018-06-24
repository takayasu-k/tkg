//
//  UIColorRGB.swift
//  TKG
//
//  Created by taka on 2018/06/24.
//  Copyright © 2018年 tkg. All rights reserved.
//

import Foundation
import UIKit


extension UIColor {
  class func rgba(red: Int, green: Int, blue: Int, alpha: CGFloat) -> UIColor{
    return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
  }
}
