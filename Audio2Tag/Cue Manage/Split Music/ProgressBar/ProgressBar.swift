//
//  ProgressBar.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/04.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct ProgressBar: View {
    @Binding var value: Int
    var foregroundColor = Color(UIColor.systemTeal)
    var backgroundColor = Color(UIColor.systemBlue)
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(self.foregroundColor)
                
                Rectangle().frame(width: min(CGFloat(Float(self.value) / 100)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(self.backgroundColor)
                    .animation(.linear)
            }.cornerRadius(45.0)
        }
    }
}
