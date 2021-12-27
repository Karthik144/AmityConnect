//
//  OverviewInfo.swift
//  AmityConnect
//
//  Created by Karthik  Ramu on 12/27/21.
//

import Foundation

struct OverviewInfo: Identifiable {
    
    var id: String = UUID().uuidString
    var title: String
    var overview: String
}
