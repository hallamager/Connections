//
//  BusinessLikeContent.swift
//  Connections
//
//  Created by Hallam John Ager on 09/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class BusinessLikedContent {
    
    let name: String!
    let foldingName: String!
    
    
    
    init(name: String, foldingName: String) {
        
        self.name = name
        self.foldingName = foldingName
        
    }
    
}


func buildContent() -> [BusinessLikedContent] {
    var likes = [BusinessLikedContent]()
    
    likes.append(BusinessLikedContent(
        name: "GREENWOOD CAMPBELL",
        foldingName: "GREENWOOD CAMPBELL"
        )
    )
    
    likes.append(BusinessLikedContent(
        name: "REDWEB",
        foldingName: "REDWEB"
        )
    )
    
    return likes
}
