//
//  CueViewModel.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/12.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI
import SwiftCueSheet
import CoreMedia

import AVFoundation

class CueMainViewModel : ObservableObject {
    @Published var isShowing = false
    @Published var status = [SplitMusicModel]()
    
}
