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
  var token: String = ""
  var client: String = ""
  var uid: String = ""
  var statusCode: Int = 0
  var menuData: MenuData!
  
  override func viewDidLoad() {
        super.viewDidLoad()

    reviewContentTextView.delegate = self
    
    let userDefaults = UserDefaults.standard
    
    self.token = userDefaults.string(forKey: "access-token")!
    self.client = userDefaults.string(forKey: "client")!
    self.uid = userDefaults.string(forKey: "uid")!
    
    
    print("viewDidLoad時点でのトークンは\(self.token)")
    print("viewDidLoad時点でのクライアントは\(self.client)")
    print("viewDidLoad時点でのユーアイデーは\(self.uid)")
//      print(self.token)
//      print(self.client)
//      print(self.uid)
    isLogedIn(token: self.token, client: self.client, uid: self.uid)
    }


  @IBAction func dismissButtonTapped(_ sender: Any) {
    // フォームを閉じる(キャンセル)処理
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func reviewPostButtonTapped(_ sender: Any) {
    
    // レビューを送信する処理を書く
    if  checkStatusCode() == true  {
      // ログインできていたら(true)以下の処理をする
      print("ログインできてる！！！！")
      
      // ログインボタンが押された時の処理
      let urlString = "http://menumeal.jp/reviews"
      var request = URLRequest(url: URL(string: urlString)!)
      
      request.httpMethod = "POST"
      request.addValue("application/json", forHTTPHeaderField: "Content-Type")
      request.addValue(self.token, forHTTPHeaderField: "access-token")
      request.addValue(self.client, forHTTPHeaderField: "client")
      request.addValue(self.uid, forHTTPHeaderField: "uid")
      
      guard let content = reviewContentTextView.text else {
        print("コンテンツの入力なし")
        return
      }
      let params: [String: Any] = [
        "menu_id": self.menuData.menuID,
        "content": content
      ]
      
      do{
        request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        //      print(params)
        print(request.httpBody!)
      }catch{
        print(error.localizedDescription)
      }
      // use NSURLSessionDataTask
      let task = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error in
        if (error == nil) {
          let result = String(data: data!, encoding: .utf8)!
          print(result)
          
          guard let response = response as? HTTPURLResponse else {
            return
          }
          
//          let token: String = response.allHeaderFields["access-token"] as! String
//          let client: String = response.allHeaderFields["client"] as! String
//          let uid: String = response.allHeaderFields["uid"] as! String
//          print("アクセストークンは：\(token)")
//          print("クライアントは：\(client)")
//          print("UIDは：\(uid)")
//          self.token = token
//          self.client = client
//          self.uid = uid
          
          self.statusCode = response.statusCode
          print("レビュー投稿のステータスコードは\(self.statusCode)")
          // ここで返却結果から必要な情報をとりだす？
        } else {
          print("error")
        }
      })
      task.resume()
    } else {
      // 未ログイン(false)なら登録画面を表示する
      print("ログインできてない！！！！")
    }
    
    // フォームを閉じる処理
    self.dismiss(animated: true, completion: nil)
  }
  
  // ユーザーのログインをチェックしてステータスコードを取得するメソッド
  func isLogedIn(token: String, client: String, uid: String) {
    // ログインしているかをチェックして真偽値を返す
    let urlString = "http://menumeal.jp/auth/validate_token"
    var request = URLRequest(url: URL(string: urlString)!)
    
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue(self.token, forHTTPHeaderField: "access-token")
    request.addValue(self.client, forHTTPHeaderField: "client")
    request.addValue(self.uid, forHTTPHeaderField: "uid")
    
    // use NSURLSessionDataTask
    let task = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error in
      if (error == nil) {
        let result = String(data: data!, encoding: .utf8)!
        print(result)
        
        guard let response = response as? HTTPURLResponse else {
          return
        }
        
        self.token = response.allHeaderFields["access-token"] as! String
        self.client = response.allHeaderFields["client"] as! String
        self.uid = response.allHeaderFields["uid"] as! String
        print("アクセストークンは：\(self.token)")
        print("クライアントは：\(self.client)")
        print("UIDは：\(self.uid)")
        
        self.statusCode = response.statusCode as Int
        print("ステータスコードは\(String(self.statusCode))でっせーーーーーーー")
        // ここで返却結果から必要な情報をとりだす？
        if self.statusCode == 200 {
          print("ログインできてる！！！！")
        }
      } else {
        print("error")
      }
    })
    task.resume()
    
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
  
  func checkStatusCode() -> Bool {
    if self.statusCode == 200 {
      print("チェック結果は\(self.statusCode)ですねん")
      return true
    } else {
      print("チェック結果は\(self.statusCode)ですねん")
      return false
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
