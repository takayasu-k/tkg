//
//  MenuDetailViewController.swift
//  TKG
//
//  Created by taka on 2018/07/29.
//  Copyright © 2018年 tkg. All rights reserved.
//

import UIKit

class MenuDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
//  var reviewsDataArray = [["userName":"ユーザー①","content":"おいしい。この店に来たら是非食べてほしいです！！(^o^)","updatedAt":"2018年7月27日"],["userName":"ユーザー②","content":"うんめぇーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー！！！！！","updatedAt":"2018年7月27日"],["userName":"ユーザー③","content":"最高です！","updatedAt":"2018年7月27日"],["userName":"ユーザー④","content":"とにかくうまい。最高にうまい。いけいけ。最高。いけてる。まじうま。激ウマ。とにかくうまい。最高にうまい。いけいけ。最高。いけてる。まじうま。激ウマ。とにかくうまい。最高にうまい。いけいけ。最高。いけてる。まじうま。激ウマ。とにかくうまい。最高にうまい。いけいけ。最高。いけてる。まじうま。激ウマ。とにかくうまい。最高にうまい。いけいけ。最高。いけてる。まじうま。激ウマ。とにかくうまい。最高にうまい。いけいけ。最高。いけてる。まじうま。激ウマ。とにかくうまい。最高にうまい。いけいけ。最高。いけてる。まじうま。激ウマ。とにかくうまい。最高にうまい。いけいけ。最高。いけてる。まじうま。激ウマ。とにかくうまい。最高にうまい。いけいけ。最高。いけてる。まじうま。激ウマ。","updatedAt":"2018年7月27日"],["userName":"ユーザー⑤","content":"おいしいですね。","updatedAt":"2018年7月27日"]]
  
  var reviewsDataArray = [ReviewData]()
  
  @IBOutlet weak var menuImageView: UIImageView!
  @IBOutlet weak var menuNameLabel: UILabel!
  @IBOutlet weak var menuPriceLabel: UILabel!
  
  @IBOutlet weak var reviewsTableView: UITableView!
  
  var imageCache = NSCache<AnyObject, UIImage>()
  var reviewsURL: String = "http://menumeal.jp/menus/1/reviews"
  var menuData: MenuData!

    override func viewDidLoad() {
        super.viewDidLoad()
      
      self.reviewsURL = "http://menumeal.jp/menus/1/reviews"
      print(reviewsURL)
      
      reviewsTableView.delegate = self
      reviewsTableView.dataSource = self
      
      menuNameLabel.text = menuData.menuName
      menuPriceLabel.text = "¥" + String(menuData.menuPrice)
      
      self.apiRequest(requestUrl: self.reviewsURL)
      
      let originalUrl = menuData.menuImage.url
      // オリジナル画像
      guard let original = originalUrl else {
        // 画像なしの場合
        menuImageView.image = UIImage(named: "noimage.png")
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
  
  
  // リクエストを行ってレビューのJSONを構造体として受け取り画面に表示するメソッド
  func apiRequest(requestUrl: String) {
    // URL生成
    guard let url = URL(string: requestUrl) else {
      // URL生成失敗
      print("URL作成できなかった")
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
        print("データがありません")
        return
      }
      
      do {
        // パース実施
        let reviewData =
          try JSONDecoder().decode([ReviewData].self, from: data)
        // 県名のリストに追加
        self.reviewsDataArray.append(contentsOf: reviewData)
      } catch let error {
        print("## error: \(error)")
      }
      
      // テーブルの描画処理を実施
      DispatchQueue.main.async {
        self.reviewsTableView.reloadData()
      }
      
    }
    // 通信開始
    task.resume()
  }

  
  // テーブルビューのデリゲート
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return reviewsDataArray.count
  }
  
  // テーブルビューのデリゲート
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewTableViewCell
    print(reviewsDataArray)
    print("ここまではおけ。")
    let reviewData = reviewsDataArray[indexPath.row]
    print(reviewData)
    
    cell.reviewContentLabel.text = reviewData.content
    cell.reviewUserNameLabel.text = "by " + reviewData.userName
    

    // String -> Date
    let dateFormater = DateFormatter()
    dateFormater.locale = Locale(identifier: "ja_JP")
    dateFormater.dateFormat = "yyyy/MM/dd'T'HH:mm:ss.SSS'Z'"
    let date = dateFormater.date(from: reviewData.updatedAt)
    guard let dateDate = date else {
      print("どやさ")
      return cell
    }
    
    // Date -> String
    let f = DateFormatter()
    f.locale = Locale(identifier: "ja_JP")
    f.dateFormat = "yyyy年MM月dd日"
    let updatedAtString = f.string(from: dateDate)
    
    
    cell.dateLabel.text = updatedAtString
    
    return cell
  }

  @IBAction func showReviewFormButtonTapped(_ sender: Any) {
    performSegue(withIdentifier: "showReviewForm", sender: nil)
  }
  



}
