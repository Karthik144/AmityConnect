//
//  NotesInfo.swift
//  AmityConnect
//
//  Created by Karthik  Ramu on 12/26/21.
//

import Foundation

struct NotesInfo: Identifiable {
    
    var id: String = UUID().uuidString
    var title: String
    var note: String
}
