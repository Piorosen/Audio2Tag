//
//  TagMainModel.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/06/22.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import Foundation

struct TagMainModel : Identifiable {
    let id = UUID()
    var index:Int
    var title:String
    var directory:String
    var fileName:String    
}
