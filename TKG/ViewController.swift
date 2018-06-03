//
//  ViewController.swift
//  TKG
//
//  Created by taka on 2018/04/21.
//  Copyright © 2018年 tkg. All rights reserved.
//


// Moreタブ用ビューコントローラ（暫定）
import UIKit

let settingsTitle = ["最新情報", "フィードバック", "アプリについて"]

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
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//     テーブルビュー必須メソッド：セルの設定
    let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
    let settingsData = settingsTitle[(indexPath as NSIndexPath).row]
    cell.textLabel?.text = settingsData

    return cell
  }


}

