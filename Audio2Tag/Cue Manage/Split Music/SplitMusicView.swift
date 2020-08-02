//
//  SplitMusicView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/21.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct SplitMusicModel : Identifiable {
    let id = UUID()
    let name: String
    var status: Int
}
//}
//
//struct ProgressView : UIViewRepresentable {
//    @Binding var data
//    init(status: Binding<Int>) {
//
//    }
//
//    func makeUIView(context: Context) -> some UIView {
//        var i = UIProgressView()
//    }
//
//}

struct SplitMusicView: View {
    @Binding var bind: [SplitMusicModel]
    
    var body: some View {
        Group {
            List(bind, id: \.self.name) { value in
                VStack {
                    Text("\(value.name) \(value.status)")
                    
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        
    }
}

