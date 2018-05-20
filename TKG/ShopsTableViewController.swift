//
//  ShopsTableViewController.swift
//  TKG
//
//  Created by taka on 2018/05/02.
//  Copyright © 2018年 tkg. All rights reserved.
//

import UIKit

class ShopsTableViewController: UITableViewController {
  
  // APIの実装ができるまでの仮データ
  // 実装後は削除する
  let shopDataArray =  [
    (shopID:"1",shopName:"十番右京",shopAddress:"東京都港区麻布十番2-6-3", shopImage: "shopSample1.jpg"),
    (shopID:"2",shopName:"喜三郎農場",shopAddress:"東京都文京区千石1-23-11", shopImage: "shopSample2.jpg"),
    (shopID:"3",shopName:"煙事",shopAddress:"東京都中央区銀座8-7-7 JUNOビル　１F", shopImage: "shopSample3.jpg"),
    (shopID:"4",shopName:"赤坂うまや",shopAddress:"東京都港区赤坂4-2-32", shopImage: "shopSample4.jpg"),
    (shopID:"5",shopName:"たまごや とよまる 松尾店",shopAddress:"〒289-1501　千葉県山武市松尾町山室431-1", shopImage: "shopSample5.jpg"),
    (shopID:"6",shopName:"九十九里ファーム たまご屋さんコッコ",shopAddress:"〒289-2232 千葉県香取郡多古町多古町喜多413-44", shopImage: "shopSample6.jpg"),
    (shopID:"7",shopName:"たまごや食堂やませ",shopAddress:"栃木県佐野市吉水町211-1 石川たまごや内", shopImage: "shopSample7.jpg")
  ]
  
  var imageUrl: String? = "https://s3-ap-northeast-1.amazonaws.com/mmx-s3-bucket01/uploads/shop/prof_picture/4/E189D55A-125F-48B7-8F31-C58F6FE2A01B.jpeg"
  
  // 前画面(都道府県名一覧)から受け取った都道府県のデータ
  var prefData: PrefData!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.title = prefData.prefName
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
      
        // 仮の画像表示のための処理
        guard let imageUrl = imageUrl else {
          // 画像なしの場合
          return cell
        }
        // 画像をダウンロードする
        guard let url = URL(string: imageUrl) else {
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
        // 画像はメインスレッド上で処理する
        DispatchQueue.main.async {
          cell.shopImageView.image = image
        }
      }
      // 画像の読み込み開始
      task.resume()
      
//        cell.shopImageView.image = UIImage(named: shopData.shopImage)
        cell.shopNameLabel.text = shopData.shopName
        cell.shopAddressLabel.text = shopData.shopAddress

        return cell
    }
  
  // セグエで移動する前にデータを受け渡す
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // セグエがshowShop(店舗詳細画面を表示する)のときに処理
    if segue.identifier == "showShop" {
      // タップした行番号を取り出す
      if let indexPath = self.tableView.indexPathForSelectedRow {
        // 行のデータを取り出す
        let shopData = shopDataArray[(indexPath).row]
        // 移動先のビューコントローラのdataプロパティに値を設定する
        (segue.destination as! ShopViewController).shopData = shopData
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
