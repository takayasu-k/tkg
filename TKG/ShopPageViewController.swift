//
//  ShopPageViewController.swift
//  TKG
//
//  Created by taka on 2018/05/06.
//  Copyright © 2018年 tkg. All rights reserved.
//

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
  func getShopMenus() -> ShopMenusViewController {
    return storyboard!.instantiateViewController(withIdentifier: "ShopMenusViewController") as! ShopMenusViewController
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
    if viewController.isKind(of: ShopMenusViewController.self) {
      // ShopMenus -> ShopInfoTable
      return getShopInfo()
    } else {
      //  -> end of the road
      return nil
    }
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    if viewController.isKind(of: ShopInfoTableViewController.self) {
      // ShopInfoTable -> ShopMenus
      return getShopMenus()
    } else {
      //  -> end of the road
      return nil
    }
  }
}

