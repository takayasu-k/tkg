//
//  ShopsTableViewController.swift
//  TKG
//
//  Created by taka on 2018/05/02.
//  Copyright © 2018年 tkg. All rights reserved.
//

import UIKit

class ShopsTableViewController: UITableViewController {
  
  var shopDataArray = [ShopData]()
  // 前画面(都道府県名一覧)から受け取った都道府県のデータ
  var prefData: PrefData!
  // 県に紐づく店舗一覧を取得するためのAPIのURL
  var shopsUrl = ""
  
  var imageCache = NSCache<AnyObject, UIImage>()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.title = prefData.prefName
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.setNavigationBarHidden(false, animated: true)
       request(requestUrl: shopsUrl)
    }
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  
  // リクエストを行ってJSONを構造体として受け取り画面に表示するメソッド
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
        let shopData =
          try JSONDecoder().decode([ShopData].self, from: data)
        // 県名のリストに追加
        self.shopDataArray.append(contentsOf: shopData)
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // テーブルのセクション数を返す(必須)
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // テーブルの行数を返す(必須)
        return shopDataArray.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShopCell", for: indexPath) as! ShopsTableViewCell
        let shopData = shopDataArray[indexPath.row]
      
        cell.shopNameLabel.text = shopData.shopName
        cell.shopAddressLabel.text = shopData.shopAddress
      
        let thumbUrl = shopData.shopImage.thumb["url"]
        // 仮の画像表示のための処理
        guard let thumb = thumbUrl!  else {
          // 画像なしの場合
          return cell
        }
      
        // キャッシュ画像があればキャッシュの画像を取り出す
        if let cacheImage = imageCache.object(forKey: thumb as AnyObject) {
          // キャッシュ画像の設定
          cell.shopImageView.image = cacheImage
          return cell
        }
      
        // 画像をダウンロードする
      
        guard let url = URL(string: thumb) else {
          // urlが生成できなかった
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
        // ダウンロードした画像をキャッシュに登録しておく
          self.imageCache.setObject(image, forKey: thumb as AnyObject)
        // 画像はメインスレッド上で処理する
        DispatchQueue.main.async {
          cell.shopImageView.image = image
        }
      }
      // 画像の読み込み開始
      task.resume()
      
//        cell.shopImageView.image = UIImage(named: shopData.shopImage)
      

        return cell
    }
  
  // セグエで移動する前にデータを受け渡す
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // セグエがshowShop(店舗詳細画面を表示する)のときに処理
    if segue.identifier == "showShopTop" {
      // タップした行番号を取り出す
      if let indexPath = self.tableView.indexPathForSelectedRow {
        // 行のデータを取り出す
        let shopData = shopDataArray[(indexPath).row]
//         移動先のビューコントローラのshopDataプロパティに値を設定する
        (segue.destination as! ShopTopViewController).shopData = shopData
      }
    }
  }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
