//
//  ViewController.swift
//  egoChat
//
//  Created by JohnPiaPian on 4/19/21.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet var nameField: UITextField!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // Methods
    func transitionToChat(){
        let chatVC = storyboard?.instantiateViewController(identifier: "chatVC") as? ChatController
        view.window?.rootViewController = chatVC
        view.window?.makeKeyAndVisible()
    }
    
    func invalidInput(){
        nameField.layer.cornerRadius = 10
        nameField.layer.borderWidth = 1
        nameField.layer.borderColor = UIColor.red.cgColor
    }
    
    public func validateName(name: String) -> Bool {
      // Length be 18 characters max and 3 characters minimum, you can always modify.
      let nameRegex = "^\\w{3,18}$"
      let trimmedString = name.trimmingCharacters(in: .whitespaces)
      let validateName = NSPredicate(format: "SELF MATCHES %@", nameRegex)
      let isValidateName = validateName.evaluate(with: trimmedString)
      return isValidateName
   }
    
    // Action
    @IBAction func Connect(_ sender: UIButton) {
        // validate input
        if validateName(name: nameField.text!) {
            // passed validation
            self.transitionToChat()
        }else{
            self.invalidInput()
        }
    }
}

