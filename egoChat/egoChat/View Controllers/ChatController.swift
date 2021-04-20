//
//  ChatController.swift
//  egoChat
//
//  Created by JohnPiaPian on 4/19/21.
//

import UIKit
import SocketIO

class ChatController: UIViewController {
    
    // Socket IO
    let manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.log(false), .compress])
    var socket:SocketIOClient!
    var name: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // **Socket
        socket = manager.defaultSocket
        addHandlers()
        socket.connect()
        
        
        // **KEYBOARD
        // Add Observer
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Tap Gesture
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    // MARK: Methods
    
    func addHandlers() {
        socket.on(clientEvent: .connect){ (data, ack) in
            let user: [String: Any] = [
                "_username": "John",
                "_userid": self.socket.sid
            ]
            self.socket?.emit("new-user", user)
        }
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
