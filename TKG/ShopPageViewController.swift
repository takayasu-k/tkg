//
//  ShopPageViewController.swift
//  TKG
//
//  Created by taka on 2018/05/06.
//  Copyright © 2018年 tkg. All rights reserved.
//

// 店舗詳細画面内のコンテナビューに接続される画面のコントローラー([詳細情報]と[メニュー一覧]を切り替える)

import UIKit

class ShopPageViewController: UIPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setViewControllers([getShopInfo()], direction: .forward, animated: true, completion: nil)
        self.dataSource = self
    }
  
  func getShopInfo() -> ShopInfoTableViewController {
    
    return storyboard!.instantiateViewController(withIdentifier: "ShopInfoTableViewController") as!ShopInfoTableViewController
  }
  func getShopMenusTable() -> ShopMenusTableViewController {
    
    return storyboard!.instantiateViewController(withIdentifier: "ShopMenusTableViewController") as! ShopMenusTableViewController
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension ShopPageViewController : UIPageViewControllerDataSource {
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    if viewController.isKind(of: ShopMenusTableViewController.self) {
      // ShopMenusTable -> ShopInfoTable
      
      let parentVC = self.parent! as! ShopViewController
      parentVC.setShopInfoButtonColor()
      return getShopInfo()
    } else {
      //  -> end of the road
      return nil
    }
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    if viewController.isKind(of: ShopInfoTableViewController.self) {
      // ShopInfoTable -> ShopMenus
      let parentVC = self.parent! as! ShopViewController
      parentVC.setShopMenusButtonColor()
      return getShopMenusTable()
    } else {
      //  -> end of the road
      return nil
    }
  }
}

