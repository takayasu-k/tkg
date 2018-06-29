//
//  WebViewController.swift
//  TKG
//
//  Created by taka on 2018/06/29.
//  Copyright © 2018年 tkg. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

  @IBOutlet weak var webView: WKWebView!
  
  
  override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      let twitterUrl = URL(string: "https://twitter.com/tkg__app?lang=ja")
      let myRequest = URLRequest(url: twitterUrl!)
      webView.load(myRequest)
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
