//
//  SearchTopTableViewController.swift
//  TKG
//
//  Created by taka on 2018/04/30.
//  Copyright © 2018年 tkg. All rights reserved.
//

import UIKit

class SearchTopTableViewController: UITableViewController {
  
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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
  
    // テーブルのセクション数を返す必須メソッド
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
  
    // テーブルの行数を返す必須メソッド
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return prefectures.count
    }

    // テーブルのセルに値を入れて返すメソッド
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrefCell", for: indexPath) as! PrefTableViewCell
        let prefData = prefectures[(indexPath as NSIndexPath).row]
        cell.prefName.text = prefData.prefName
        cell.shopCount.text = "(\(prefData.shopCount))"
      
        return cell
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
