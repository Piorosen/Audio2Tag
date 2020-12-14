//
//  CueSheetFile.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/12/14.
//

import Foundation

struct CueSheetFile : Identifiable {
    var id = UUID()
    var fileName: String
    var fileType: String
}
