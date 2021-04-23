//
//  MessageTableViewCell_B.swift
//  egoChat
//
//  Created by JohnPiaPian on 4/23/21.
//

import UIKit

class MessageTableViewCell_B: UITableViewCell {
    
    @IBOutlet var name: UILabel!
    @IBOutlet var textMsg: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        textMsg.layer.cornerRadius = 10
        textMsg.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        textMsg.layer.borderWidth = 0.5
        textMsg.clipsToBounds = true
        //textMsg.contentInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5) // padding
        textMsg.textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5) // padding, fix overflow
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
