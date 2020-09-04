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
    
    init(deviceFilePath: URL, haveID3Tag: Bool) {
        _fileName = deviceFilePath.deletingPathExtension().lastPathComponent
        _ext = deviceFilePath.pathExtension
        _deviceFilePath = deviceFilePath
        
        self.haveID3Tag = haveID3Tag
    }
    
    private var _fileName: String = String()
    private var _ext:String = String()
    private var _deviceFilePath: URL
    
    var fileName:String {
        get
        {
            return _fileName
        }
    }
    var ext:String {
        get
        {
            return _ext
        }
    }
    
    var deviceFilePath:URL {
        get {
            return _deviceFilePath
        }
        set {
            _fileName = newValue.deletingPathExtension().lastPathComponent
            _ext = newValue.pathExtension
            _deviceFilePath = newValue
        }
    }
    let haveID3Tag: Bool
    
}
