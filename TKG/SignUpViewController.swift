//
//  SignUpViewController.swift
//  TKG
//
//  Created by taka on 2018/08/01.
//  Copyright © 2018年 tkg. All rights reserved.
//

// サインアップ画面の処理

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {

  
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var userNameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var passwordConfirmTextField: UITextField!
  var token: String = ""
  var client: String = ""
  var uid: String = ""
  var userName: String = ""
  var statusCode: Int = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    emailTextField.delegate = self
    userNameTextField.delegate = self
    passwordTextField.delegate = self
    passwordConfirmTextField.delegate = self
    passwordTextField.isSecureTextEntry = true
    passwordConfirmTextField.isSecureTextEntry = true
  }

  @IBAction func signUpButtonTapped(_ sender: Any) {
    // 新規登録ボタンが押された時の処理
    let urlString = "http://menumeal.jp/auth"
    var request = URLRequest(url: URL(string: urlString)!)
    
    request.httpMethod = "POST"
//    request.addValue("", forHTTPHeaderField: "Content-Type")
    // set the header(s)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    guard let email = emailTextField.text else {
      print("emailの入力なし")
      return
    }
    guard let name = userNameTextField.text else {
      print("ユーザー名の入力なし")
      return
    }
    self.userName = name
    guard let password = passwordTextField.text else {
      print("パスワードの入力なし")
      return
    }
    guard let passwordConfirmation = passwordConfirmTextField.text else {
      print("パスワード(確認)の入力なし")
      return
    }
    
    let params: [String: Any] = [
      "email": email,
      "name": name,
      "password": password,
      "password_confirmation": passwordConfirmation
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
        
        self.statusCode = response.statusCode
        print("ステータスコードは\(String(self.statusCode))")
        
        // ここで返却結果から必要な情報をとりだす？
      } else {
        print("error")
      }
    })
    task.resume()
    
      
    self.performSegue(withIdentifier: "toLogIn", sender: nil)
  }
  
  
  @IBAction func toLogInButtonTapped(_ sender: Any) {
    // ログインページヘ遷移する処理
    
    performSegue(withIdentifier: "toLogIn", sender: nil)
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toLogIn" {
      (segue.destination as! LogInViewController).token = self.token
      (segue.destination as! LogInViewController).client = self.client
      (segue.destination as! LogInViewController).token = self.uid
      (segue.destination as! LogInViewController).userName = self.userName
    }
  }

}
