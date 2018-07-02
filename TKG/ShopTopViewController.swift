//
//  ShopTopViewController.swift
//  TKG
//
//  Created by taka on 2018/06/28.
//  Copyright © 2018年 tkg. All rights reserved.
//

import UIKit

class ShopTopViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  var imageCache = NSCache<AnyObject, UIImage>()
  // 前画面から受け取った店舗の基本情報
  var shopData: ShopData!
  
  // 店舗詳細データの雛形
  var shopInfo:[(key:String,value:String)] = [
    ("住所",""),
    ("電話",""),
    ("営業時間",""),
    ("定休日",""),
    ("支払い方法","")
  ]
  
  @IBOutlet weak var navItem: UINavigationItem! // Navigationバーのタイトル
  @IBOutlet weak var shopInfoTableView: UITableView!
  @IBOutlet weak var shopImageView: UIImageView!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var scrollContentView: UIView!
  

    override func viewDidLoad() {
        super.viewDidLoad()
        shopInfoTableView.isScrollEnabled = false
        shopInfoTableView.delegate = self
        shopInfoTableView.dataSource = self
      
        // shopDataが設定されていればshopDataに代入する
        guard let shopData = shopData else {
          return
        }
        guard let shopUrl = shopData.shopImage.url else {
          return
        }
        navItem.title = shopData.shopName
      
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
          self.shopImageView.image = UIImage(named: "noimage.png")
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
      
      let shopDetailUrl = "http://menumeal.jp/shops/\(self.shopData.shopID)/"
      shopInfo[0].value = (shopData.shopAddress)
      shopInfo[1].value = (shopData.shopTel)!
      requestShopDetail(requestUrl: shopDetailUrl)
    }
  override func viewDidLayoutSubviews() {
    let contentSize = scrollContentView.bounds.size
    scrollView.contentSize = CGSize(width: contentSize.width, height: contentSize.height+60)
    
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    // tableViewの行数を返す必須メソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return shopInfo.count
    }
  
    // セルを作成する必須メソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "ShopInfoCell", for: indexPath) as! ShopInfoTableViewCell
      cell.shopInfoTitleLabel.text = shopInfo[indexPath.row].key
      cell.shopInfoValueLabel.text = shopInfo[indexPath.row].value
      
      return cell
    }
  
    // リクエストを行って店舗詳細情報のJSONを構造体として受け取り画面に表示するメソッド
    func requestShopDetail(requestUrl: String) {
      // URL生成
      guard let url = URL(string: requestUrl) else {
        // URL生成失敗
        return
      }
      // リクエスト生成
      let request = URLRequest(url: url)
      
      let session = URLSession.shared
      let task = session.dataTask(with: request) {
        (data:Data?, response:URLResponse?, error:Error?) in
        // 通信完了後の処理
        // エラーチェック
        guard error == nil else {
          // error表示
          let alert = UIAlertController(title: "エラー",
                                        message: error?.localizedDescription,
                                        preferredStyle: UIAlertControllerStyle.alert)
          // UIに関する処理はメインスレッド上で行う
          DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
          }
          return
        }
        // JSONで返却されたデータをパースして格納する
        guard let data = data else {
          // データなし
          return
        }
        
        do {
          // パース実施
          let shopDetail =
            try JSONDecoder().decode(ShopDetail.self, from: data)
          // 県名のリストに追加
          if let operagingHours = shopDetail.operatingHours {
            self.shopInfo[2].value = operagingHours
          } else {
            self.shopInfo[2].value = ""
          }
          if let holiday = shopDetail.holiday {
            self.shopInfo[3].value = holiday
          } else {
            self.shopInfo[3].value = ""
          }
          if let payment = shopDetail.payment {
            self.shopInfo[4].value = payment
          } else {
            self.shopInfo[4].value = ""
          }
          
        } catch let error {
          print("## error: \(error)")
        }
        
        // テーブルの描画処理を実施
        DispatchQueue.main.async {
          self.shopInfoTableView.reloadData()
        }
        
      }
      // 通信開始
      task.resume()
    }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // セグエがshowShopMenus(店舗メニューを表示する)のときに処理
    if segue.identifier == "showShopMenus" {
        //         移動先のビューコントローラのshopDataプロパティに値を設定する
        (segue.destination as! ShopMenusTableViewController).shopData = shopData
    }
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
