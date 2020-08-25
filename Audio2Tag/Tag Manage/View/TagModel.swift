//
//  TagModel.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/24.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import Foundation
import SwiftUI
import ID3TagEditor

struct TagFrameModel : Identifiable {
    let id = UUID()
    var key: FrameName
    var value: ID3Frame
}

struct TagModel : Identifiable {
    let id = UUID()
    
    let tagVersion: ID3Version
    var tagFrame: [TagFrameModel]
    var image = UIImage()
}
