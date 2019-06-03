//
//  MessageController.swift
//  BullitinBoard
//
//  Created by William Moody on 6/3/19.
//  Copyright © 2019 William Moody. All rights reserved.
//

import Foundation
import CloudKit

class MessageController {
    
    //Singleton
    static let shared = MessageController()
    
    //Source of truth
    var messages: [Message] = []
    //dataBase being used
    let privateDB = CKContainer.default().privateCloudDatabase
    
    //CRUD
    //create
    func createMessage(text: String, timeStamp: Date) {
        let message = Message(text: text, timeStamp: timeStamp)
        self.saveMessage(message: message) { (error) in
            
        }
    }
    //Remove
    func removeMessage(message: Message, completion: @escaping (Bool) -> ()) {
        //remove locally
        guard let index = MessageController.shared.messages.index(of: message) else {completion(false); return}
        MessageController.shared.messages.remove(at: index)
        //remove from cloud
        privateDB.delete(withRecordID: message.ckRecordID) { (_, error) in
            if let error = error {
                print("🚒🚒🚒🚒🚒\(error.localizedDescription) \(error) in function: \(#function)🚒🚒🚒🚒🚒")
                completion(false)
                return
            }else {
                print("message deleted")
                completion(true)
            }
        }
    }
    //Save
    func saveMessage(message:Message, completion: @escaping (Bool) -> ()){
        let messageRecord = CKRecord(message: message)
        privateDB.save(messageRecord) { (record, error) in
            if let error = error{
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(false)
                return
            }
            guard let record = record, let message = Message(ckRecord: record) else {completion(false); return}
            self.messages.append(message)
            completion(true)
        }
    }
    //Load
    func fetchMessages(completion: @escaping (Bool) -> ()) {
        //predicate used to determine how items fetched are organized
        let predicate = NSPredicate(value: true)
        let querry = CKQuery(recordType: Constants.recordKey, predicate: predicate)
        
        privateDB.perform(querry, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("🚒🚒🚒🚒🚒\(error.localizedDescription) \(error) in function: \(#function)🚒🚒🚒🚒🚒")
                completion(false)
                return
            }
            //Record
            guard let records = records else {completion(false); return}
            let messages = records.compactMap({Message(ckRecord: $0)})
            self.messages = messages
            completion(true)
        }
    }
}
