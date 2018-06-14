//
//  MenuDetailViewController.swift
//  TKG
//
//  Created by taka on 2018/06/10.
//  Copyright © 2018年 tkg. All rights reserved.
//

import UIKit

class MenuDetailViewController: UIViewController {
  
//  let menuData = (menuID:"2",menuName:"博多明太子の玉子焼き",menuPrice:"1100",menuImage:"menu2.jpg")

  var menuData: MenuData!
  var menuImage: UIImage!
  @IBOutlet weak var menuImageView: UIImageView!
  @IBOutlet weak var menuNameLabel: UILabel!
  @IBOutlet weak var menuPriceLabel: UILabel!
  
  override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//    menuImageView.image = UIImage(named: menuData.menuImage)

    menuNameLabel.text = menuData.menuName
    menuPriceLabel.text = "¥" + String(menuData.menuPrice)
    if let menuImage = menuImage {
      menuImageView.image = menuImage
    } else {
      return
    }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
