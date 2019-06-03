//
//  messageListTableViewController.swift
//  BullitinBoard
//
//  Created by William Moody on 6/3/19.
//  Copyright © 2019 William Moody. All rights reserved.
//

import UIKit

class messageListTableViewController: UITableViewController {
    @IBOutlet weak var messageText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MessageController.shared.fetchMessages { (yay) in
            if yay{
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
        // MARK: - Table view data source
    }
    @IBAction func postButtonTapped(_ sender: Any) {
        guard let messageTextUsed = messageText.text else {return}
        MessageController.shared.createMessage(text: messageTextUsed, timeStamp: Date())
        messageText.text = ""
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return MessageController.shared.messages.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        
        let message = MessageController.shared.messages[indexPath.row]
        cell.textLabel?.text = message.text
        cell.detailTextLabel?.text = DateFormatter.dateFormat(fromTemplate: "\(message.timeStamp)", options: 0, locale: Locale(identifier: "en_US"))
        // Configure the cell..
        
        return cell
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let message = MessageController.shared.messages[indexPath.row]
            // Delete the row from the data source
            MessageController.shared.removeMessage(message: message) { (success) in
                if success {
                    DispatchQueue.main.async {
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

