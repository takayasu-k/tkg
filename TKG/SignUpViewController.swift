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

  }
  
  
  @IBAction func toLogInButtonTapped(_ sender: Any) {
    // ログインページヘ遷移する処理
    
    performSegue(withIdentifier: "toLogIn", sender: nil)
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
