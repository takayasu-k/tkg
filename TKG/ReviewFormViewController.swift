//
//  ReviewFormViewController.swift
//  TKG
//
//  Created by taka on 2018/07/29.
//  Copyright © 2018年 tkg. All rights reserved.
//

import UIKit

class ReviewFormViewController: UIViewController, UITextViewDelegate {

  @IBOutlet weak var reviewContentTextView: UITextView!
  
  override func viewDidLoad() {
        super.viewDidLoad()

      reviewContentTextView.delegate = self
    
    }


  @IBAction func dismissButtonTapped(_ sender: Any) {
    // フォームを閉じる(キャンセル)処理
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func reviewPostButtonTapped(_ sender: Any) {
    // レビューを送信する処理を書く
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
