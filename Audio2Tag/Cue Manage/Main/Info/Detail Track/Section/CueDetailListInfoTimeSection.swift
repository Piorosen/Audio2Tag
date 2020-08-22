//
//  CueDetailListInfoTimeSection.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/22.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct CueDetailListInfoTimeSection: View {
    var body: some View {
        Section(header: Text("Time Info")) {
            HStack {
                Text("Start Time")
                Spacer()
                Text(self.viewModel.startTime)
            }
            HStack {
                Text("End Time")
                Spacer()
                Text(self.viewModel.endTime)
            }
            HStack {
                Text("Wait Time")
                Spacer()
                Text(self.viewModel.waitTime)
            }
            HStack {
                Text("Duration Time")
                Spacer()
                Text(self.viewModel.durTime)
            }
        }
    }
}
