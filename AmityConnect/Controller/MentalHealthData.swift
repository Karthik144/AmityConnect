//
//  MentalHealthData.swift
//  AmityConnect
//
//  Created by Karthik  Ramu on 1/10/22.
//

import Foundation


struct MentalHealthData: Identifiable {

    var id: String = UUID().uuidString
    var name: String
    var activity_level: Float
    var date: Date
    var additional_notes: String
    var mood_level: Float

}
