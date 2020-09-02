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

//struct TagFrameModel : Identifiable {
//    let id = UUID()
//    var key: FrameName
//    var value: ID3Frame
//}

struct TagModel : Identifiable {
    let id = UUID()
    var fileName:String {
        get
        {
            return deviceFilePath.deletingPathExtension().lastPathComponent
        }
    }
    var ext:String {
        get
        {
            return deviceFilePath.pathExtension
        }
    }
    
    var deviceFilePath:URL
    let haveID3Tag: Bool
    
}
