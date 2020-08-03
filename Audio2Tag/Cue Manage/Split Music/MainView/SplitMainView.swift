//
//  SplitMainView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/04.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct SplitMainView: View {
    // = CGSize(width: 300, height: 400)
    var size: CGSize
    @Binding var isPresented: Bool
    @Binding var bind: [SplitMusicModel]
    
    var body: some View {
        VStack(spacing: 0) {
            ProgressScrollView(bind: self._bind)
            
            Button(action: {
                self.isPresented = false
            }) {
                Text("OK")
                .frame(maxWidth: .infinity)
                .background(Color.black)
            }
            .padding(10)
            
            
        }
        .frame(width: size.width, height: size.height)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 100)
        .overlay(RoundedRectangle(cornerRadius: 15)
            .stroke(Color.black, lineWidth: 1)
        )
    }
}
