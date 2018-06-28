//
//  ShopMenusTableViewController.swift
//  TKG
//
//  Created by taka on 2018/05/12.
//  Copyright © 2018年 tkg. All rights reserved.
//

import UIKit

class ShopMenusTableViewController: UITableViewController {
  
   var menuDataArray = [MenuData]() // MenuData型の配列
   var imageCache = NSCache<AnyObject, UIImage>()
   // 前画面から受け取った店舗の基本情報
   var shopData: ShopData!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
      
      guard let shopData = shopData else {
        return
      }
      let menuUrl = "http://menumeal.jp/shops/\(shopData.shopID)/menus"
      
      request(requestUrl: menuUrl)
    }
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menuDataArray.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shopMenuCell", for: indexPath) as! ShopMenusTableViewCell
        let menuData = menuDataArray[(indexPath as NSIndexPath).row]
        cell.menuNameLabel.text = menuData.menuName
        cell.menuPriceLabel.text = String(menuData.menuPrice)
      
      let thumbUrl = menuData.menuImage.thumb["url"]
      // サムネイル
      guard let thumb = thumbUrl!  else {
        // 画像なしの場合
        cell.menuImageView.image = UIImage(named: "noImageThumb.png")
        return cell
      }
      
      // キャッシュサムネイル画像があればキャッシュの画像を取り出す
      if let cacheImage = imageCache.object(forKey: thumb as AnyObject) {
        // キャッシュ画像の設定
        cell.menuImageView.image = cacheImage
        return cell
      }
      
      // サムネイルをダウンロードする
      guard let url = URL(string: thumb) else {
        // サムネurlが生成できなかった
        return cell
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
        self.imageCache.setObject(image, forKey: thumb as AnyObject)
        // 画像はメインスレッド上で処理する
        DispatchQueue.main.async {
          cell.menuImageView.image = image
        }
      }
      // サムネの読み込み開始
      task.resume()
      
      return cell
    }
  
  // リクエストを行ってメニューのJSONデータを構造体として受け取り画面に表示するメソッド
  func request(requestUrl: String) {
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
        let menuData =
          try JSONDecoder().decode([MenuData].self, from: data)
        // メニューのリストに追加
        self.menuDataArray.append(contentsOf: menuData)
      } catch let error {
        print("## error: \(error)")
      }
      
      // テーブルの描画処理を実施
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
      
    }
    // 通信開始
    task.resume()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showMenu" {
      // タップした行番号を取り出す
      if let indexPath = self.tableView.indexPathForSelectedRow {
        // 行のデータを取り出す
        let menuData = menuDataArray[(indexPath).row]
        // 移動先ビューコントローラのprefDataプロパティに値を設定する
        (segue.destination as! MenuDetailViewController).menuData = menuData
      }
    }
  }
  
  




}
