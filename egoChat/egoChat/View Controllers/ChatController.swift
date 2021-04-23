//
//  ChatController.swift
//  egoChat
//
//  Created by JohnPiaPian on 4/19/21.
//

import UIKit
import SocketIO

class ChatController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var sendBtn: UIButton!
    @IBOutlet var msgField: UITextField!
    @IBOutlet var tableView: UITableView!
    
    // Socket IO variables
    let manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.log(false), .compress])
    var socket: SocketIOClient!
    
    // Messages data for TableView
    var messages = [[String:String]]()
    var activeUsers = [[String:String]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ** Socket
        socket = manager.defaultSocket
        addHandlers()
        socket.connect()
        
        // ** TableView
        let nib = UINib(nibName: "MessageTableViewCell", bundle: nil);
        tableView.register(nib, forCellReuseIdentifier: "MessageTableViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // ** Keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    // Actions
    @IBAction func sendMsg(_ sender: Any) {
        if checkTextFieldIsNotEmpty(_string: msgField.text!){
            sendMsg(msg: trimString(_string: msgField.text!))
            clearInput(field: msgField)
            clearInvalidInput(field: msgField)
        }else{
            invalidInput(field: msgField)
        }
    }
    
    @IBAction func isTyping(_ sender: UITextField) {
        let user: [String: Any] = [
            "_username": currentUser["username"]!,
            "_userid": currentUser["userid"]!,
            "_isTyping": (sender.text!.count > 0 && sender.text!.count < 5)
        ]
        
        self.socket.emit("user-typing", user)
    }
    
    
    // TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell",
                                                 for: indexPath) as! MessageTableViewCell
        
        cell.name.text = (messages[indexPath.row]["_userid"] == currentUser["userid"] as? String) ? "You" : messages[indexPath.row]["_username"]
        cell.textMsg.text = messages[indexPath.row]["_msg"]
        
        return cell
    }
    
    // Add new messages to View
    func updateMessages(){
        tableView.reloadData()
        
        // Scroll to newest message
        let numberOfSections = self.tableView.numberOfSections
        let numberOfRows = self.tableView.numberOfRows(inSection: numberOfSections-1)
        let indexPath = IndexPath(row: numberOfRows-1 , section: numberOfSections-1)
        self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }
    
    // Add "is typing" to View
    func isTyping(field: UITextField, data: [String:Any]){
        if (data["_isTyping"] as? Bool) == true {
            field.placeholder = data["_username"] as! String + " is typing."
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) { // do stuff x seconds later
                field.placeholder = ""
            }
        }
    }
    
    
    // Handle SocketIO events
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
            //print("New user!")
            
            if let _activeUsers = data[0] as? [[String:String]]{
                self?.activeUsers = _activeUsers
            }
        }
        
        // When a new message is sent
        socket.on("new-message") {[weak self] data, ack in
            //print("New message!")
            
            if let _data = data[0] as? [String:String]{
                self?.messages.append(_data)
            }
            
            self?.updateMessages()
        }
        
        // When a user is typing
        socket.on("user-typing") {[weak self] data, ack in
            //print("User typing!")
            
            if let _data = data[0] as? [String:Any]{
                self?.isTyping(field: (self?.msgField)!, data: _data)
            }
            
        }
        
        // When a user disconnected
        socket.on("user-disconnected") {[weak self] data, ack in
            //print("User disconnected!")
            
            if let _activeUsers = data[0] as? [[String:String]]{
                self?.activeUsers = _activeUsers
            }
        }
    }
    
    // Send a new message to everyone
    func sendMsg(msg: String){
        let data: [String: Any] = [
            "_username": currentUser["username"]!,
            "_userid": currentUser["userid"]!,
            "_msg": msg
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
