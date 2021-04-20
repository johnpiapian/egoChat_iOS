//
//  ChatController.swift
//  egoChat
//
//  Created by JohnPiaPian on 4/19/21.
//

import UIKit
import SocketIO

class ChatController: UIViewController {
    
    @IBOutlet var sendBtn: UIButton!
    @IBOutlet var msgField: UITextField!
    
    
    // Socket IO variables
    let manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.log(false), .compress])
    var socket: SocketIOClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // **Socket
        socket = manager.defaultSocket
        addHandlers()
        socket.connect()
        
        
        // **KEYBOARD
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    // MARK: Methods
    @IBAction func sendMsg(_ sender: Any) {
        if checkTextFieldIsNotEmpty(text: msgField.text!){
            sendMsg(msg: (msgField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!)
            msgField.text = ""
            clearInvalidInput(filed: msgField)
        }else{
            invalidInput(field: msgField)
        }
    }
    
    
    func addHandlers() {
        // When connection is established
        socket.on(clientEvent: .connect){ (data, ack) in
            
            currentUser["userid"] = self.socket.sid
            
            let user: [String: Any] = [
                "_username": currentUser["username"]!,
                "_userid": currentUser["userid"]!
            ]
            
            self.socket?.emit("new-user", user)
        }
        
        // When a new user joined
        socket.on("new-user") {[weak self] data, ack in
            print("New user!")
            print(data)
        }
        
        // When a new message is sent
        socket.on("new-message") {[weak self] data, ack in
            print("New message!")
            print(data)
        }
        
        // When a user is typing
        socket.on("user-typing") {[weak self] data, ack in
            print("User typing!")
            print(data)
        }
        
        // When a user disconnected
        socket.on("user-disconnected") {[weak self] data, ack in
            print("Disconnected!")
            print(data)
        }
    }
    
    func sendMsg(msg: String){
        let data: [String: Any] = [
            "username": currentUser["username"]!,
            "userid": currentUser["userid"]!,
            "msg": msg
        ]
        socket.emit("new-message", data)
    }
    
    // Keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height
                }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        if ((notification.userInfo? [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y = 0
            }
        }
    }

}
