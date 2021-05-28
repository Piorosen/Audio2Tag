//
//  CueView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/11/12.
//

import SwiftUI

struct CueView2: View {
    @State var show = false
    @State var pp = [CueStatusCellModel]()
    var body: some View {
        ZStack {
            CueEditView()
                // CueSheet, Save Directory, Audio Directory
                .onRequestExecute {
                    print("\($0) : \($1) : \($2)")
                }
                // CueSheet, Save Directory
                // Need : FileName
                .onRequestSaveCueSheet { _, _ in
                    print("ddd")
                    
                }.onRequestStatus {
                    show.toggle()
                }
            CueStatusView(isPresented: $show, bind: $pp)
        }
    }
}

struct CueView2_Previews: PreviewProvider {
    static var previews: some View {
        CueView2()
    }
}
