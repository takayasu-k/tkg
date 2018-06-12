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
  
  var imageCache = NSCache<AnyObject, UIImage>()
  // 前画面から受け取った店舗の基本情報
  var shopData: ShopData!

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
    guard let shopUrl = shopData.shopImage.url else {
      return
    }
    shopNameTitle.title = shopData.shopName
    
    
    // キャッシュ画像があればキャッシュの画像を取り出す
    if let cacheImage = imageCache.object(forKey: shopUrl as AnyObject) {
      // キャッシュ画像の設定
      self.shopImageView.image = cacheImage
      return
    }
    
    // キャッシュになければ画像をダウンロードする
    guard let url = URL(string: shopUrl) else {
      // urlが生成できなかった
      return
    }
    let request = URLRequest(url: url)
    let session = URLSession.shared
    let task = session.dataTask(with: request) { (data:Data?, response:URLResponse?, error: Error?) in
      guard error == nil else {
        // エラー有り
        return
      }
      guard let data = data else {
        // データが存在しない
        return
      }
      guard let image = UIImage(data: data) else {
        // imageが生成できなかった
        return
      }
      // ダウンロードした画像をキャッシュに登録しておく
      self.imageCache.setObject(image, forKey: shopUrl as AnyObject)
      // 画像はメインスレッド上で処理する
      DispatchQueue.main.async {
        self.shopImageView.image = image
      }
    }
    // 画像の読み込み開始
    task.resume()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  @IBAction func showShopInfoTapped(_ sender: Any) {
    let childVC = self.childViewControllers[0] as! ShopPageViewController
    if childVC.childViewControllers[0].isKind(of: ShopMenusTableViewController.self) {
      childVC.setViewControllers([childVC.getShopInfo()], direction: .reverse, animated: true, completion: nil)
      setShopInfoButtonColor()
    }
    
  }
  @IBAction func showShopMenuTapped(_ sender: Any) {
    let childVC = self.childViewControllers[0] as! ShopPageViewController
    if childVC.childViewControllers[0].isKind(of: ShopInfoTableViewController.self) {
      childVC.setViewControllers([childVC.getShopMenusTable()], direction: .forward, animated: true, completion: nil)
      setShopMenusButtonColor()
    }
    
  }
  
  func setShopInfoButtonColor() {
    showShopInfoButton.setTitleColor(UIColor.orange, for: .normal)
    showShopMenuButton.setTitleColor(UIColor.lightGray, for: .normal)
  }
  func setShopMenusButtonColor() {
    showShopInfoButton.setTitleColor(UIColor.lightGray, for: .normal)
    showShopMenuButton.setTitleColor(UIColor.orange, for: .normal)
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
