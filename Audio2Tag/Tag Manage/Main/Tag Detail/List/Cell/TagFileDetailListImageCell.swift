//
//  TagFileDetailListImageCell.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/09/06.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct TagFileDetailListImageCellView: View {
    @Binding var image: UIImage
    
    var body: some View {
        Group {
            GeometryReader { (g:GeometryProxy) in
                ZStack {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: g.size.width, height: g.size.height, alignment: .center)
                        .aspectRatio(contentMode: .fill)
                        .blur(radius: 15)
                        .colorInvert()
                    
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: g.size.width / 2, height: g.size.height / 2, alignment: .center)
                        .aspectRatio(contentMode: .fit)
                    VStack {
                        Spacer()
                        HStack {
                            Button(action: {
                                print("a")
                            }) {
                                Image(systemName: "minus.circle")
                            }
                            Spacer()
                            Button(action: {
                                print("b")
                            }) {
                                Image(systemName: "plus.circle")
                            }
                            
                        }
                    }
                    
                }
            }
        }
    }
}
