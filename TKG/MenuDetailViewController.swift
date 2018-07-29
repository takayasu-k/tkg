//
//  MenuDetailViewController.swift
//  TKG
//
//  Created by taka on 2018/07/29.
//  Copyright © 2018年 tkg. All rights reserved.
//

import UIKit

class MenuDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  let reviewDataArray = [["userName":"ユーザー①","content":"おいしい。この店に来たら是非食べてほしいです！！(^o^)","updatedAt":"2018年7月27日"],["userName":"ユーザー②","content":"うんめぇーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー！！！！！","updatedAt":"2018年7月27日"],["userName":"ユーザー③","content":"最高です！","updatedAt":"2018年7月27日"],["userName":"ユーザー④","content":"とにかくうまい。最高にうまい。いけいけ。最高。いけてる。まじうま。激ウマ。とにかくうまい。最高にうまい。いけいけ。最高。いけてる。まじうま。激ウマ。とにかくうまい。最高にうまい。いけいけ。最高。いけてる。まじうま。激ウマ。とにかくうまい。最高にうまい。いけいけ。最高。いけてる。まじうま。激ウマ。とにかくうまい。最高にうまい。いけいけ。最高。いけてる。まじうま。激ウマ。とにかくうまい。最高にうまい。いけいけ。最高。いけてる。まじうま。激ウマ。とにかくうまい。最高にうまい。いけいけ。最高。いけてる。まじうま。激ウマ。とにかくうまい。最高にうまい。いけいけ。最高。いけてる。まじうま。激ウマ。とにかくうまい。最高にうまい。いけいけ。最高。いけてる。まじうま。激ウマ。","updatedAt":"2018年7月27日"],["userName":"ユーザー⑤","content":"おいしいですね。","updatedAt":"2018年7月27日"]]
  
  @IBOutlet weak var menuImageView: UIImageView!
  @IBOutlet weak var menuNameLabel: UILabel!
  @IBOutlet weak var menuPriceLabel: UILabel!
  
  @IBOutlet weak var reviewsTableView: UITableView!
  
  var imageCache = NSCache<AnyObject, UIImage>()
  
  var menuData: MenuData!

    override func viewDidLoad() {
        super.viewDidLoad()
      
      reviewsTableView.delegate = self
      reviewsTableView.dataSource = self
      
      menuNameLabel.text = menuData.menuName
      menuPriceLabel.text = "¥" + String(menuData.menuPrice)
      
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
  

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return reviewDataArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewTableViewCell
    let reviewData = reviewDataArray[indexPath.row]
    
    cell.dateLabel.text = reviewData["updatedAt"]
    cell.reviewContentLabel.text = reviewData["content"]
    cell.reviewUserNameLabel.text = "by " + reviewData["userName"]!
    
    return cell
  }





}
