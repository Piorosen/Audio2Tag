//
//  CueView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/11/12.
//

import SwiftUI

extension String {
    static func random(length: Int, list: String = "1234567890qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM") -> String {
        var result = ""
        
        for _ in 0..<length {
            if let p = list.randomElement() {
                result += String(p)
            }
        }
        
        return result
    }
}

struct CueView: View {
    @State var show = true
    @State var pp = [CueStatusCellModel]()
    var body: some View {
        ZStack {
            CueEditView()
                .onRequestExecute {_ in 
                    pp.append(CueStatusCellModel(name: String.random(length: 8), value: Double.random(in: 0...1)))
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
