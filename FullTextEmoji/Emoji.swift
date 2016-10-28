//
//  Emoji.swift
//  FullTextEmoji
//
//  Created by Paul Wood on 10/26/16.
//  Copyright © 2016 Paul Wood. All rights reserved.
//

import Foundation

class Emoji {
    var title : String
    var keywords : [String]
    var char : String
    var category : String
    var fts : String
    
    init(title incTitle: String, dictionary : [String: Any]){
        title = incTitle
        keywords = dictionary["keywords"] as! [String]
        char = dictionary["char"] as! String
        category = dictionary["category"] as! String
        var composing = keywords.joined(separator: "|")
        composing = title + composing
        composing = char + composing
        composing = category + composing
        fts = composing
    }
    
}

extension Emoji : CustomStringConvertible {
    public var description: String {
        get {
            return "\(title): \(char)"
        }
    }
}
