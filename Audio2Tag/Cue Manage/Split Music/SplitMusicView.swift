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
    var drag:()->Void = { }
    
//    let data = [1,2,3,4,5,6,7,8,9,1,2,3,4,5,6,7,8,9,1,2,3,4,5,6,7,8,9,1,2,3,4,5,6,7,8,9]
    
    var size: CGSize = CGSize(width: 300, height: 400)
    @State var lastDragPosition:DragGesture.Value? = nil
    @State var offsetHeight: CGFloat = .zero
    
    func onDrag(eventHandler: @escaping () -> Void) -> SplitMusicView {
        var copy = self
        copy.drag = eventHandler
        return copy
    }
    
    var body: some View {
        Group {
            VStack(spacing: 0) {
                ScrollView {
                    ForEach(self.bind) { value in
                        Text("\(value.name) : \(value.status)").frame(height: 40)
                            .frame(maxWidth: .infinity)
                    }.frame(maxWidth: .infinity, maxHeight: .infinity)
                }
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
//            .overlay(RoundedRectangle(cornerRadius: 15)
//                .stroke(Color.black, lineWidth: 1)
//            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.opacity(0.1))
        .offset(y: self.isPresented ? self.offsetHeight : UIScreen.main.bounds.height)
        .animation(.spring())
        .gesture(DragGesture().onChanged { value in
            self.lastDragPosition = value
            self.offsetHeight = value.translation.height
        }.onEnded { value in
            guard let lastDragPosition = self.lastDragPosition else {
                return
            }
            let timeDiff = value.time.timeIntervalSince(lastDragPosition.time)
            let speed:CGFloat = CGFloat(value.translation.height - lastDragPosition.translation.height) / CGFloat(timeDiff)
            print("\(speed)")
            self.offsetHeight = .zero
            if(speed > 500) {
                self.drag()
            }
        })
    }
}
