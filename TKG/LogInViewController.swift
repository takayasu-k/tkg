//
//  LogInViewController.swift
//  TKG
//
//  Created by taka on 2018/08/02.
//  Copyright © 2018年 tkg. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController, UITextFieldDelegate {

  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  var token: String = ""
  var client: String = ""
  var uid: String = ""
  var userName: String = ""
  var statusCode: Int = 0
  
  override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
    }

  @IBAction func logInButtonTapped(_ sender: Any) {
    // ログインボタンが押された時の処理
    let urlString = "http://menumeal.jp/auth/sign_in"
    var request = URLRequest(url: URL(string: urlString)!)
    
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue(self.token, forHTTPHeaderField: "access-token")
    request.addValue(self.client, forHTTPHeaderField: "client")
    request.addValue(self.uid, forHTTPHeaderField: "uid")
    
    guard let email = emailTextField.text else {
      print("emailの入力なし")
      return
    }
    guard let password = passwordTextField.text else {
      print("パスワードの入力なし")
      return
    }
    
    let params: [String: Any] = [
      "email": email,
      "password": password
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
        
        let token: String = response.allHeaderFields["access-token"] as! String
        let client: String = response.allHeaderFields["client"] as! String
        let uid: String = response.allHeaderFields["uid"] as! String
        print("アクセストークンは：\(token)")
        print("クライアントは：\(client)")
        print("UIDは：\(uid)")
        self.token = token
        self.client = client
        self.uid = uid
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(self.token, forKey: "access-token")
        userDefaults.set(self.client, forKey: "client")
        userDefaults.set(self.uid, forKey: "uid")
        userDefaults.set(self.userName, forKey: "userName")
        userDefaults.synchronize()
        
        print("ユーザーデフォルト上でのアクセストークンは：\(userDefaults.string(forKey: "access-token"))")
        print("ユーザーデフォルト上でのクライアントは：\(userDefaults.string(forKey: "client"))")
        print("ユーザーデフォルト上でのUIDは：\(userDefaults.string(forKey: "uid"))")
        
        
        self.statusCode = response.statusCode
        print("ステータスコードは\(self.statusCode)")
        // ここで返却結果から必要な情報をとりだす？
      } else {
        print("error")
      }
    })
    task.resume()
    
    print("次のステータスコードは\(self.statusCode)")
    self.performSegue(withIdentifier: "toHomeView", sender: nil)
  }
  
    
  @IBAction func toSignUpButtonTapped(_ sender: Any) {
    performSegue(withIdentifier: "toSignUp", sender: nil)
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    // キーボードを閉じる
    textField.resignFirstResponder()
    return true
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toHomeView" {
      let userDefaults = UserDefaults.standard
      userDefaults.set(self.token, forKey: "access-token")
      userDefaults.set(self.client, forKey: "client")
      userDefaults.set(self.uid, forKey: "uid")
      userDefaults.set(self.userName, forKey: "userName")
      userDefaults.synchronize()
    }
  }

}
