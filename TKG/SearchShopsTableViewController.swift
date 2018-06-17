//
//  SearchShopsTableViewController.swift
//  TKG
//
//  Created by taka on 2018/06/17.
//  Copyright © 2018年 tkg. All rights reserved.
//

import UIKit

class SearchShopsTableViewController: UITableViewController, UISearchBarDelegate {
  
  @IBOutlet weak var shopsSearchBar: UISearchBar!
  var shopDataArray = [ShopData]()
   var imageCache = NSCache<AnyObject, UIImage>()
  let entryUrl: String = "http://menumeal.jp/shops/search"
   var searchText = ""

    override func viewDidLoad() {
        super.viewDidLoad()
      
      self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
      self.navigationController?.setNavigationBarHidden(false, animated: true)
      shopsSearchBar.delegate = self

      shopsSearchBar.text = searchText
      // 保持している店舗データをいったん削除
      shopDataArray.removeAll()
      
      // パラメーターの指定
      let parameter = ["q": searchText]
      
      // パラメーターをエンコードしたURLをつくる
      let requestUrl = createRequestUrl(parameter: parameter)
      // APIをリクエストする
      print(requestUrl)
      request(requestUrl: requestUrl)
    }
  
    override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    // 入力された文字の取り出し
    guard let inputText = searchBar.text else {
      //　入力された文字なし
      return
    }
    
    // 入力の文字数チェック
    guard inputText.lengthOfBytes(using: String.Encoding.utf8) > 0 else {
      // 文字数０以下の場合
      return
    }
    
    // 保持している店舗データをいったん削除
    shopDataArray.removeAll()
    
    // パラメーターの指定
    let parameter = ["q" : inputText]
    
    // パラメーターをエンコードしたURLをつくる
    let requestUrl = createRequestUrl(parameter: parameter)
    
    // APIをリクエストする
    request(requestUrl: requestUrl)
    
    // キーボードを閉じる
    searchBar.resignFirstResponder()
  }
  
  // パラメーターのURLエンコード処理
  func encodeParameter(key: String, value: String) -> String? {
    // 値のエンコード処理
    guard let escapedValue = value.addingPercentEncoding(withAllowedCharacters:  CharacterSet.urlQueryAllowed) else {
      // エンコード失敗
      return nil
    }
    // エンコードした値を返却する
    return "\(key)=\(escapedValue)"
  }
  
  // URL作成処理
  func createRequestUrl(parameter: [String: String]) -> String {
    var parameterString = ""
    for key in parameter.keys {
      // 値の取り出し
      guard let value = parameter[key] else {
        // 値なし次の処理
        continue
      }
      // すでにパラメーターが設定されていた場合
      if parameterString.lengthOfBytes(using: String.Encoding.utf8) > 0 {
        // パラメーター同士のセパレータである+を追加する
        parameterString += "+"
      }
      // 値をエンコードする
      guard let encodeValue = encodeParameter(key: key, value: value) else {
        // エンコード失敗
        continue
      }
      // エンコードした値をパラメーターとして追加
      parameterString += encodeValue
    }
    let requestUrl = entryUrl + "?" + parameterString
    return requestUrl
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
    if segue.identifier == "showShop" {
      // タップした行番号を取り出す
      if let indexPath = self.tableView.indexPathForSelectedRow {
        // 行のデータを取り出す
        let shopData = shopDataArray[(indexPath).row]
        //         移動先のビューコントローラのshopDataプロパティに値を設定する
        (segue.destination as! ShopViewController).shopData = shopData
      }
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
