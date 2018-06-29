//
//  ViewController.swift
//  TKG
//
//  Created by taka on 2018/04/21.
//  Copyright © 2018年 tkg. All rights reserved.
//


// Moreタブ用ビューコントローラ（暫定）
import UIKit

let settingsTitle = ["Twitter", "バージョン"]

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var settingsTableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    settingsTableView.delegate = self
    settingsTableView.dataSource = self
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  func numberOfSections(in tableView: UITableView) -> Int {
    // テーブルビュー必須メソッド：セクションの数
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // テーブルビュー必須メソッド：テーブルの行数
    return settingsTitle.count
  }
  
  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    
    switch indexPath.row {
    case 0:
      return indexPath
    // 選択不可にしたい場合は"nil"を返す
    case 1:
      return nil
      
    default:
      return indexPath
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//     テーブルビュー必須メソッド：セルの設定
    let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsTableViewCell
    let settingsData = settingsTitle[(indexPath as NSIndexPath).row]
    cell.settingsContentLabel.text = settingsData
    
    if indexPath.row == 1 {
      // セルの選択不可にする
      cell.selectionStyle = .none
      let version: String! = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
      cell.contentLabel.text = version
      cell.accessoryType = UITableViewCellAccessoryType.none
    } else {
      // セルの選択を許可
      cell.selectionStyle = .default
    }

    return cell
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showPrefShops" {
     
    } else if segue.identifier == "showVersion" {
      
    }
  }

}

