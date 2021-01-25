//
//  CueStatusView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/11/12.
//

import SwiftUI


struct CueStatusView: View {
    @Binding var isPresented: Bool
    
    @Binding var bind: [CueStatusCellModel]
    
    var body: some View {
        CustomAlertView(isPresent: $isPresented, title: "데이터 분리 상태", ok: {
            print("yeess")
        }) {
            List {
                
                CueStatusCellView(data: CueStatusCellModel(name: "전체 진행률", value: bind.count == 0
                                                            ? 0
                                                            : bind.map{ $0.value }.reduce(0.0, +) / Double(bind.count)))
                ForEach (bind) { item in
                    CueStatusCellView(data: item)
                }
            }.scaledToFit()
        }
    }
}

struct CueStatusView_Previews: PreviewProvider {
    @State static  var bind = [CueStatusCellModel(name: "a1", value: 0.3),
                               CueStatusCellModel(name: "a2", value: 0.1),
                               CueStatusCellModel(name: "a3", value: 0.5),
                               CueStatusCellModel(name: "a4", value: 0.7),
                               CueStatusCellModel(name: "a5", value: 0.9),
                               CueStatusCellModel(name: "a6", value: 0.3),]
    @State static var pre = false
    static var previews: some View {
        CueStatusView(isPresented: $pre, bind: $bind)
    }
}
