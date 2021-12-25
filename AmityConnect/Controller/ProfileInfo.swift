//
//  ProfileInfo.swift
//  AmityConnect
//
//  Created by Karthik  Ramu on 12/24/21.
//

import Foundation

struct ProfileInfo : Identifiable {
    
    var full_name: String
    var id: String = UUID().uuidString
    var email: String
    var position: String
    var centerId: String
        

}

