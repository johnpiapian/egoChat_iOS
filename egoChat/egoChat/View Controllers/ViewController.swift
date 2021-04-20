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
    
    // **Methods
    func transitionToChat(){
        let chatVC = storyboard?.instantiateViewController(identifier: "chatVC") as? ChatController
        view.window?.rootViewController = chatVC
        view.window?.makeKeyAndVisible()
    }
    
    // **Actions
    @IBAction func Connect(_ sender: UIButton) {
        // validate input
        if validateName(name: nameField.text!) { // valid
            currentUser["username"] = nameField.text // Set global username
            self.transitionToChat()
        }else{
            invalidInput(field: nameField)
        }
    }
}

