//
//  SplitMusicView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/21.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

extension Color {
    static func randColor() -> Color {
        return Color(red: Double.random(in: 0...1), green: Double.random(in: 0...1), blue: Double.random(in: 0...1))
    }
}

struct SplitMusicView: View {
    //    @Binding var bind: [SplitMusicModel]
    @Binding var isPresented: Bool
    let data = [1,2,3,4,5,6,7,8,9,1,2,3,4,5,6,7,8,9,1,2,3,4,5,6,7,8,9,1,2,3,4,5,6,7,8,9]
    // 민지,
    //
    
    
    var body: some View {
        Group {
            VStack {
                ScrollView {
                    ForEach(self.data, id: \.self) { value in
                        Text("\(value)").frame(height: 40)
                            .frame(maxWidth: .infinity)
                            .background(Color.randColor())
                            
                    }.frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                Button(action: {
                    self.isPresented = false
                }) {
                    Text("OK")
                }
                .padding(10).frame(maxWidth: .infinity)
                
            }
            .background(Color(UIColor.systemBackground))
            .cornerRadius(15)
            .shadow(radius: 100)
            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.black, lineWidth: 1))
        }
        .frame(width: 300, height: 400)
        .offset(y: self.isPresented ? 0 : UIScreen.main.bounds.height)
        .animation(.spring())
    }
}

