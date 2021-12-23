//
//  ElderOverview.swift
//  AmityConnect
//
//  Created by Karthik  Ramu on 12/22/21.
//

import Foundation

struct ElderOverview: Identifiable {
    
    var id: String = UUID().uuidString
    var age: String
    var caretaker: String
    var condition: String
    var family_email: String
    var name: String
}
