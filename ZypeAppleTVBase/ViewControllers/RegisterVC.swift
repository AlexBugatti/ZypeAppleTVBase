//
//  RegisterVC.swift
//  ZypeAppleTVBase
//
//  Created by Andrey Kasatkin on 3/30/17.
//  Copyright © 2017 Zype. All rights reserved.
//

import Foundation

class RegisterVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.addTarget(self, action: #selector(onRegister(_:)), for: UIControlEvents.editingDidEnd)
    }
    
    @IBAction func onRegister(_ sender: UIButton) {
        if let email = self.emailTextField.text, let password = self.passwordTextField.text {
            if(email.isEmpty) {
                presentAlertWithText("Register.EmailEmpty")
            } else if(password.isEmpty) {
                presentAlertWithText("Register.PasswordEmpty")
            } else {
                
                let consumer = ConsumerModel(name: email, email: email, password: password)
                ZypeAppleTVBase.sharedInstance.createConsumer(consumer, completion: { (success, error, message) -> Void in
                    if(success == true) {
                        ZypeAppleTVBase.sharedInstance.login(email, passwd: password, completion: { (logedIn, error) -> Void in
                           
                            if(logedIn){
                                UserDefaults.standard.set(true, forKey: kDeviceLinkedStatus)
                                NotificationCenter.default.post(name: Notification.Name(rawValue: kZypeReloadScreenNotification), object: nil)
                                self.dismiss(animated: true, completion: {_ in})
                            } else {
                              
                            }
                        })
                    } else {
                     
                       self.presentAlertWithText(message)
                    }
                })
            }
        }
    }
    
    func presentAlertWithText(_ message : String){
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let ignoreAction = UIAlertAction(title: "Ok", style: .cancel) { _ in
            
        }
        alertController.addAction(ignoreAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
}
