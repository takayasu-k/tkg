//
//  ButtonCustom.swift
//  TKG
//
//  Created by taka on 2018/06/28.
//  Copyright © 2018年 tkg. All rights reserved.
//

import Foundation

import UIKit

@IBDesignable

class Button_Custom: UIButton {
  @IBInspectable var textColor: UIColor?
  @IBInspectable var cornerRadius: CGFloat = 0 {
    didSet {
      layer.cornerRadius = cornerRadius
    }
  }
  @IBInspectable var borderWidth: CGFloat = 0 {
    didSet {
      layer.borderWidth = borderWidth
    }
  }
  
  @IBInspectable var borderColor: UIColor = UIColor.clear {
    didSet {
      layer.borderColor = borderColor.cgColor
    }
  }
}
