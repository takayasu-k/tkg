//
//  ShopMenusViewController.swift
//  TKG
//
//  Created by taka on 2018/05/06.
//  Copyright © 2018年 tkg. All rights reserved.
//

// 店舗のメニュー一覧表示用ビューコントローラ、テーブルビューかコレクションビューのデリゲート設定をする（未定）

import UIKit

class ShopMenusViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var shopMenusTableView: UITableView!
  
  // APIの実装ができるまでの仮データ
  // 実装後は削除する
  let menuDataArray =  [
    (menuID:"1",menuName:"みつせ鶏串",menuPrice:"400",menuImage:"menu1.jpg"),
    (menuID:"2",menuName:"博多明太子の玉子焼き",menuPrice:"1100",menuImage:"menu2.jpg"),
    (menuID:"3",menuName:"大分 別府湾 釜揚げしらすの玉子焼き",menuPrice:"1050",menuImage:"menu3.jpg"),
    (menuID:"4",menuName:"黒豚のスペアリブ",menuPrice:"1000",menuImage:"menu4.jpg"),
    (menuID:"5",menuName:"佐賀 唐津 川島豆腐店の胡麻豆腐",menuPrice:"500",menuImage:"menu5.jpg"),
    (menuID:"6",menuName:"鹿児島 黒豚ばら肉しゃぶしゃぶ鍋",menuPrice:"3600",menuImage:"menu6.jpg"),
    (menuID:"7",menuName:"うまや特製 杏仁豆腐",menuPrice:"620",menuImage:"menu7.jpg"),
    (menuID:"8",menuName:"もち豚の炭火焼きとろろ定食",menuPrice:"1300",menuImage:"menu8.jpg"),
    (menuID:"9",menuName:"麓鶏のチキンカツ定食",menuPrice:"1250",menuImage:"menu9.jpg"),
    (menuID:"10",menuName:"佐賀 シシリアンライス",menuPrice:"1150",menuImage:"menu10.jpg"),
  ]

    override func viewDidLoad() {
        super.viewDidLoad()

        shopMenusTableView.delegate = self
        shopMenusTableView.dataSource = self
        shopMenusTableView.isScrollEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    cell.menuImageView.image = UIImage(named: menuData.menuImage)
    cell.menuNameLabel.text = menuData.menuName
    cell.menuPriceLabel.text = menuData.menuPrice
    
    return cell
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
