//
//  ProgressBar.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/06/23.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct ProgressBar: View {
    @Binding var value: Float
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color(NSColor.systemTeal))
                
                Rectangle().frame(width: min(CGFloat(self.value)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(Color(NSColor.systemBlue))
                    .animation(.linear)
            }.cornerRadius(45.0)
        }
    }
}
struct ProgressBar_Previews: PreviewProvider {
    @State static var test:Float = 20.0
    static var previews: some View {
        ProgressBar(value: self.$test)
    }
}
