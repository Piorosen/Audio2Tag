//
//  SplitMusicView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/21.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct SplitMusicView: View {
    @Binding var bind: [SplitMusicModel]
    @Binding var isPresented: Bool
    
    var size: CGSize = CGSize(width: 300, height: 400)
    @State var lastDragPosition:DragGesture.Value? = nil
    @State var offsetHeight: CGFloat = .zero
    
    var body: some View {
        Group {
            VStack(spacing: 0) {
                List(0..<bind.count, id: \.self) { index in
                    SplitMusicCell(bind: self.$bind[index])
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                
                Divider()
                
                Button(action: {
                    self.isPresented = false
                }) {
                    Text("OK").padding(10).frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)
            }
            .frame(width: size.width, height: size.height)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(15)
            .shadow(radius: 100)
        }
        .offset(y: self.isPresented ? self.offsetHeight : UIScreen.main.bounds.height)
    }
}
