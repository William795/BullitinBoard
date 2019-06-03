//
//  Message.swift
//  BullitinBoard
//
//  Created by William Moody on 6/3/19.
//  Copyright © 2019 William Moody. All rights reserved.
//

import Foundation
import CloudKit

struct Constants {
    static let recordKey = "Message"
    static let textKey = "text"
    static let timeStampKey = "timestamp"
}

class Message{
    var text: String
    var timeStamp: Date
    var ckRecordID: CKRecord.ID
    
    //created values in local memory
    //preparing for cloud
    init(text: String, timeStamp: Date, ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.text = text
        self.timeStamp = timeStamp
        self.ckRecordID = ckRecordID
    }
    
    //using values to get specific record
    convenience init?(ckRecord: CKRecord) {
        guard let text = ckRecord[Constants.textKey] as? String, let timestamp = ckRecord[Constants.timeStampKey] as? Date else {return nil}
        
        self.init(text: text, timeStamp: timestamp, ckRecordID: ckRecord.recordID)
    }
}

// sending to cloud
extension CKRecord {
    convenience init(message: Message) {
        self.init(recordType: Constants.recordKey, recordID: message.ckRecordID)
        self.setValue(message.text, forKey: Constants.textKey)
        self.setValue(message.timeStamp, forKey: Constants.timeStampKey)
    }
}

extension Message: Equatable {
    static func == (lhs: Message, rhs: Message) -> Bool {
        <#code#>
    }
}
