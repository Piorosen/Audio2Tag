//
//  TagSearchTrackViewModel.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/25.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import Foundation
import SwiftUI

class TagSearchTrackViewModel : ObservableObject {
    @Published var items = [String]()
    @Published var showIndicator = false
    
    func musicBrainz(id:String) {
        
    }
    func vgmDb(id:String) {
        
    }
}
