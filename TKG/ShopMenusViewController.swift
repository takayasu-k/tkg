//
//  ShopMenusViewController.swift
//  TKG
//
//  Created by taka on 2018/05/06.
//  Copyright © 2018年 tkg. All rights reserved.
//

// 店舗のメニュー一覧表示用ビューコントローラ、テーブルビューかコレクションビューのデリゲート設定をする（未定）

import UIKit

class ShopMenusViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  
  @IBOutlet weak var Segment: UISegmentedControl!
  
  @IBOutlet var ListView: UIView!
  @IBOutlet var GridView: UIView!
  
  @IBOutlet weak var shopMenusTableView: UITableView!
  @IBOutlet weak var shopMenusCollectionView: UICollectionView!
  
  var Indicator: UIActivityIndicatorView!
  
  var menuDataArray = [MenuData]() // MenuData型の配列
  var imageCache = NSCache<AnyObject, UIImage>()
  // 前画面から受け取った店舗の基本情報
  var shopData: ShopData!
  
    override func viewDidLoad() {
        super.viewDidLoad()

        shopMenusTableView.delegate = self
        shopMenusTableView.dataSource = self
        shopMenusCollectionView.delegate = self
        shopMenusCollectionView.dataSource = self
      
      guard let shopData = shopData else {
        return
      }
      let menuUrl = "http://menumeal.jp/shops/\(shopData.shopID)/menus"
      
      request(requestUrl: menuUrl)
      
      // 追加するViewのHeightがSegumentの下につくように設定
      // 追加するViewのHeightがSegumentの下につくように設定
      ListView.frame = CGRect(x: 0,
                              y: Segment.frame.minY + Segment.frame.height,
                              width: self.view.frame.width,
                              height: (self.view.frame.height - Segment.frame.minY))
      GridView.frame = CGRect(x: 0,
                              y: Segment.frame.minY + Segment.frame.height,
                              width: self.view.frame.width,
                              height: (self.view.frame.height - Segment.frame.minY))
      
      self.view.addSubview(ListView)

    }

  @IBAction func changeLayout(_ sender: UISegmentedControl) {
    switch sender.selectedSegmentIndex {
    case 0:
      addListView()
    case 1:
      addGridView()
    default:
      addListView()
    }
  }

  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return menuDataArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let horizontalSpace:CGFloat = 1
    let cellsize:CGFloat = self.view.bounds.width/3 - horizontalSpace
    return CGSize(width: cellsize, height: cellsize)
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return menuDataArray.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath) as! ShopMenusCollectionViewCell
    let menuData = menuDataArray[indexPath.item]
    let priceString = "¥" + String(menuData.menuPrice)
    cell.menuPriceButton.setTitle(priceString, for: .normal)
    
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
        self.shopMenusTableView.reloadData()
      }
      
    }
    // 通信開始
    task.resume()
  }
  
  // GridViewをViewから削除し、ListViewをViewに追加する
  func addListView() {
    GridView.removeFromSuperview()
    self.view.addSubview(ListView)
  }
  
  // ListViewをViewから削除し、GridViewをViewに追加する
  func addGridView() {
    ListView.removeFromSuperview()
    self.view.addSubview(GridView)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "listShowMenu" {
      // タップした行番号を取り出す
      if let indexPath = self.shopMenusTableView.indexPathForSelectedRow {
        // 行のデータを取り出す
        let menuData = menuDataArray[(indexPath).row]
        // 移動先ビューコントローラのprefDataプロパティに値を設定する
        (segue.destination as! MenuDetailViewController).menuData = menuData
      }
    } else if segue.identifier == "gridShowMenu" {
      let indexPath = self.shopMenusCollectionView.indexPathsForSelectedItems![0]
        // 行のデータを取り出す
        let menuData = menuDataArray[indexPath.row]
        // 移動先ビューコントローラのprefDataプロパティに値を設定する
        (segue.destination as! MenuDetailViewController).menuData = menuData
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
