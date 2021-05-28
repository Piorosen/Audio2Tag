//
//  CueView.swift
//  Audio2Tag
//
//  Created by aoikazto on 2021/05/28.
//

import Foundation
import SwiftUI

struct CueView: View {
    @State var statusPresent = false
    @State var cellModel = [CueStatusCellModel]()
    var body: some View {
        ZStack {
            CueSelectView()
            CueStatusView(isPresented: $statusPresent, bind: $cellModel)
        }
    }
}

struct CueView_Previews: PreviewProvider {
    static var previews: some View {
        CueView()
    }
}
