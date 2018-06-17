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

  var imageCache = NSCache<AnyObject, UIImage>()
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
    
    let originalUrl = menuData.menuImage.url
    // オリジナル画像
    guard let original = originalUrl else {
      // 画像なしの場合
      return
    }
    
    // キャッシュのオリジナル画像があればキャッシュの画像を取り出す
    if let cacheImage = imageCache.object(forKey: original as AnyObject) {
      // キャッシュ画像の設定
      menuImageView.image = cacheImage
      return
    }
    // サムネイルをダウンロードする
    guard let url = URL(string: original) else {
      // オリジナル画像urlが生成できなかった
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
      // ダウンロードしたサムネ画像をキャッシュに登録しておく
      self.imageCache.setObject(image, forKey: original as AnyObject)
      // 画像はメインスレッド上で処理する
      DispatchQueue.main.async {
        self.menuImageView.image = image
      }
    }
    // サムネの読み込み開始
    task.resume()

    
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
