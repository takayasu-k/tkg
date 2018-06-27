//
//  ShopInfoTableViewController.swift
//  TKG
//
//  Created by taka on 2018/05/06.
//  Copyright © 2018年 tkg. All rights reserved.
//

import UIKit

// 店舗の基本情報表示用テーブルビューコントローラ
class ShopInfoTableViewController: UITableViewController {
  
  var shopInfo:[(key:String,value:String)] = [
    ("住所",""),
    ("電話",""),
    ("営業時間",""),
    ("定休日",""),
    ("支払い方法","")
  ]
  var VCSize:CGSize = CGSize(width: 0, height: 0)

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.isScrollEnabled = false
        let shopView = self.parent as! ShopPageViewController
        let shopData = shopView.shopData
        let shopID = shopView.shopData.shopID
       let shopDetailUrl = "http://menumeal.jp/shops/\(shopID)/"
      shopInfo[0].value = (shopData?.shopAddress)!
      shopInfo[1].value = (shopData?.shopTel)!
       request(requestUrl: shopDetailUrl)
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    override func viewWillLayoutSubviews() {
      self.VCSize = self.view.frame.size
      let shopVC = self.parent?.parent as! ShopViewController
      shopVC.scrollView.contentSize = CGSize(width: VCSize.width, height: VCSize.height)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return shopInfo.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShopInfoCell", for: indexPath) as! ShopInfoTableViewCell
        cell.shopInfoTitleLabel.text = shopInfo[indexPath.row].key
        cell.shopInfoValueLabel.text = shopInfo[indexPath.row].value

        return cell
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
        self.tableView.reloadData()
      }
      
    }
    // 通信開始
    task.resume()
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
