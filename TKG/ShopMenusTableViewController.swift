//
//  ShopMenusTableViewController.swift
//  TKG
//
//  Created by taka on 2018/05/12.
//  Copyright © 2018年 tkg. All rights reserved.
//

import UIKit

class ShopMenusTableViewController: UITableViewController {
  
  // APIの実装ができるまでの仮データ
  // 実装後は削除する
//  let menuDataArray =  [
//    (menuID:"1",menuName:"みつせ鶏串",menuPrice:"400",menuImage:"menu1.jpg"),
//    (menuID:"2",menuName:"博多明太子の玉子焼き",menuPrice:"1100",menuImage:"menu2.jpg"),
//    (menuID:"3",menuName:"大分 別府湾 釜揚げしらすの玉子焼き",menuPrice:"1050",menuImage:"menu3.jpg"),
//    (menuID:"4",menuName:"黒豚のスペアリブ",menuPrice:"1000",menuImage:"menu4.jpg"),
//    (menuID:"5",menuName:"佐賀 唐津 川島豆腐店の胡麻豆腐",menuPrice:"500",menuImage:"menu5.jpg"),
//    (menuID:"6",menuName:"鹿児島 黒豚ばら肉しゃぶしゃぶ鍋",menuPrice:"3600",menuImage:"menu6.jpg"),
//    (menuID:"7",menuName:"うまや特製 杏仁豆腐",menuPrice:"620",menuImage:"menu7.jpg"),
//    (menuID:"8",menuName:"もち豚の炭火焼きとろろ定食",menuPrice:"1300",menuImage:"menu8.jpg"),
//    (menuID:"9",menuName:"麓鶏のチキンカツ定食",menuPrice:"1250",menuImage:"menu9.jpg"),
//    (menuID:"10",menuName:"佐賀 シシリアンライス",menuPrice:"1150",menuImage:"menu10.jpg"),
//    ]
   var menuDataArray = [MenuData]()
   var imageCache = NSCache<AnyObject, UIImage>()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
      let shopView = parent as! ShopPageViewController
      guard let shopData = shopView.shopData else {
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
        // 県名のリストに追加
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
