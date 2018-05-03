//
//  SearchTopViewController.swift
//  TKG
//
//  Created by taka on 2018/04/30.
//  Copyright © 2018年 tkg. All rights reserved.
//

import UIKit

// APIの実装ができるまでの仮データ
// 実装後は削除する
let prefectures =  [
  (prefID:"1",prefName:"北海道",shopCount:"3"),
  (prefID:"3",prefName:"秋田",shopCount:"2"),
  (prefID:"10",prefName:"東京",shopCount:"100"),
  (prefID:"25",prefName:"千葉",shopCount:"20"),
  (prefID:"30",prefName:"神奈川",shopCount:"13"),
  (prefID:"33",prefName:"京都",shopCount:"5"),
  (prefID:"45",prefName:"福岡",shopCount:"10")
]

class SearchTopViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var prefTableView: UITableView!
  
  override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        prefTableView.delegate = self
        prefTableView.dataSource = self
    }
  override func viewDidAppear(_ animated: Bool) {
    self.navigationController?.setNavigationBarHidden(true, animated: false)
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return prefectures.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PrefCell", for: indexPath) as! PrefTableViewCell
    let prefData = prefectures[(indexPath as NSIndexPath).row]
    cell.prefName.text = prefData.prefName
    cell.shopCount.text = "(\(prefData.shopCount))"
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let prefData = prefectures[indexPath.row]
    performSegue(withIdentifier: "showPrefShops", sender: prefData)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showPrefShops" {
      // タップした行番号を取り出す
      if let indexPath = self.prefTableView.indexPathForSelectedRow {
        // 行のデータを取り出す
        let prefData = prefectures[(indexPath).row]
        // 移動先ビューコントローラのprefDataプロパティに値を設定する
        (segue.destination as! ShopsTableViewController).prefData = prefData
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
