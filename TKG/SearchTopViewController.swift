//
//  SearchTopViewController.swift
//  TKG
//
//  Created by taka on 2018/04/30.
//  Copyright © 2018年 tkg. All rights reserved.
//

import UIKit


class SearchTopViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var prefTableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!
  
  // 店舗のある都道府県一覧と店舗数を返すURL
  let prefUrl = "http://menumeal.jp/pref_shops/search"
  
  // テーブルビューに表示するための都道府県名の情報
  var prefDataArray = [PrefData]()
  
  override func viewDidLoad() {
        super.viewDidLoad()

        prefTableView.delegate = self
        prefTableView.dataSource = self
  }
  
  override func viewDidAppear(_ animated: Bool) {
    self.navigationController?.setNavigationBarHidden(true, animated: false)
  }
  
  // 画面が表示される直前に毎回行われる↓
  override func viewWillAppear(_ animated: Bool) {
    // 保持している県情報を一旦削除
    prefDataArray.removeAll()
    
    request(requestUrl: prefUrl)
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let prefData =
          try JSONDecoder().decode([PrefData].self, from: data)
        // 県名のリストに追加
        self.prefDataArray.append(contentsOf: prefData)
      } catch let error {
        print("## error: \(error)")
      }
      
      // テーブルの描画処理を実施
      DispatchQueue.main.async {
        self.prefTableView.reloadData()
      }
      
    }
    // 通信開始
    task.resume()
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // 表示する行の数を返す
    return prefDataArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PrefCell", for: indexPath) as! PrefTableViewCell
    let prefData = prefDataArray[(indexPath as NSIndexPath).row]
    cell.prefName.text = prefData.prefName
    cell.shopCount.text = "(\(String(prefData.shopCount)))"
    
    return cell
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showPrefShops" {
      // タップした行番号を取り出す
      if let indexPath = self.prefTableView.indexPathForSelectedRow {
        // 行のデータを取り出す
        let prefData = prefDataArray[(indexPath).row]
        // 移動先ビューコントローラのprefDataプロパティに値を設定する
        (segue.destination as! ShopsTableViewController).prefData = prefData
        (segue.destination as! ShopsTableViewController).shopsUrl = "http://menumeal.jp/pref_shops/\(String(prefData.prefID))/shops/search"
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
