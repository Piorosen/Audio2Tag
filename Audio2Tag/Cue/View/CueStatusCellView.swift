//
//  CueStatusCellView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/11/12.
//

import SwiftUI

struct CueStatusCellView: View {
    var data: CueStatusCellModel
    
    var body: some View {
        VStack {
            Text("\(data.name)")
                .frame(maxWidth: .infinity, alignment: .leading)
            ProgressView(value: Float(data.value), total: 1)
        }.padding(10)
    }
}

struct CueStatusCellView_Previews: PreviewProvider {
    static var previews: some View {
        CueStatusCellView(data: CueStatusCellModel(name: "hi", value: 0.1))
    }
}
