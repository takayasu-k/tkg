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
  
  override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
    }

  @IBAction func logInButtonTapped(_ sender: Any) {
  }
  
    
  @IBAction func toSignUpButtonTapped(_ sender: Any) {
    performSegue(withIdentifier: "toSignUp", sender: nil)
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
