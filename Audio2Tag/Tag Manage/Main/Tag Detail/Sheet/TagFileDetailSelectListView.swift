//
//  TagFileDetailSelectListView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/30.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct TagFileDetailSelectListView: View {
    @Binding var isPresent: Bool
    
    var body: some View {
        GeometryReader { (g: GeometryProxy) in
            VStack {
                
                Divider()
                HStack {
                    Button(action: {
                        withAnimation {
                            isPresent = false
                        }
                    }) {
                        Text("Dismiss")
                    }
                }
            }
            .padding()
            .background(Color.white)
            .frame(
                width: g.size.width*0.7,
                height: g.size.height*0.7
            )
            .shadow(radius: 1)
            .opacity(self.isPresent ? 1 : 0)
        }
    }
}
