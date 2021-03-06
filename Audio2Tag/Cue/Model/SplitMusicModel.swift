//
//  SplitMusicModel.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/21.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import Foundation

struct SplitMusicModel : Identifiable {
    let id = UUID()
    let name: String
    var status: Int
}
