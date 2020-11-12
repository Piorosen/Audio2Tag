//
//  CueStatusCellModel.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/11/12.
//

import Foundation

struct CueStatusCellModel : Identifiable {
    let id = UUID()
    let name: String
    var value: Double
}
