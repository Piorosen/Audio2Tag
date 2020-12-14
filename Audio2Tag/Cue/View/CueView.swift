//
//  CueView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/11/12.
//

import SwiftUI

struct CueView: View {
    @State var show = false
    @State var pp = [CueStatusCellModel]()
    var body: some View {
        ZStack {
            CueEditView()
                .onRequestExecute {_, _ in 

                }.onRequestStatus {
                    show.toggle()
                }
            CueStatusView(isPresented: $show, bind: $pp)
        }
    }
}

struct CueView_Previews: PreviewProvider {
    static var previews: some View {
        CueView()
    }
}
