//
//  CenterInfo.swift
//  AmityConnect
//
//  Created by Karthik  Ramu on 12/24/21.
//

import Foundation

struct CenterInfo : Identifiable {
    
    var id: String = UUID().uuidString
    var centerId: String
    var director: String
    var location: String
    var memberSince: Date
    var memberSinceString: String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd 'of' MMMM"
        return formatter.string(from: memberSince)

    }
        

}
