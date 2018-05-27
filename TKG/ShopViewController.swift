//
//  ShopViewController.swift
//  TKG
//
//  Created by taka on 2018/05/02.
//  Copyright © 2018年 tkg. All rights reserved.
//

// 店舗詳細画面(店舗トップ)のビューコントローラ

import UIKit

class ShopViewController: UIViewController {
  
  // 前画面から受け取った店舗の基本情報
  var shopData:(shopID:String,shopName:String,shopAddress:String,shopImage:String)?

  @IBOutlet weak var shopImageView: UIImageView! // 店舗トップ画像imageView
  @IBOutlet weak var shopNameTitle: UINavigationItem! // navigationItem店舗名
  @IBOutlet weak var showShopInfoButton: UIButton!
  @IBOutlet weak var showShopMenuButton: UIButton!
  
  override func viewDidLoad() {
        super.viewDidLoad()

        // shopDataが設定されていればshopDataに代入する
    guard let shopData = shopData else {
      return
    }
    shopNameTitle.title = shopData.shopName
    shopImageView.image = UIImage(named: shopData.shopImage)
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
