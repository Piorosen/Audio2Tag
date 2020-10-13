//
//  CueDetailListInfoTimeSection.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/22.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI
import CoreMedia


struct CueDetailListInfoTimeSection: View {
    let startTime: String
    let endTime: String
    let waitTime:String
    let durationTime: String
    
    var body: some View {
        Group {
            Section(header: Text("Time Info")) {
                HStack {
                    Text("Start Time")
                    Spacer()
                    Text(self.startTime)
                }
                HStack {
                    Text("End Time")
                    Spacer()
                    Text(self.endTime)
                }
                HStack {
                    Text("Wait Time")
                    Spacer()
                    Text(self.waitTime)
                }
                HStack {
                    Text("Duration Time")
                    Spacer()
                    Text(self.durationTime)
                }
            }
        }
    }
}
