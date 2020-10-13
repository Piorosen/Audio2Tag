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
    @State var openSheet = false
    @State var alert = false
    
    var body: some View {
        Group {
            GeometryReader { (g:GeometryProxy) in
                ZStack {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: g.size.width, height: g.size.height, alignment: .center)
                        .aspectRatio(contentMode: .fill)
                        .blur(radius: 15)
                    Button(action: {
                        openSheet = true
                    }) {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }.frame(width: g.size.width, height: g.size.height)
                    
//                    VStack {
//                        Spacer()
//                        HStack {
//                            Button(action: {
//                                print("a")
//                            }) {
//                                Image(systemName: "minus.circle")
//                            }
//                            Spacer()
//                            Button(action: {
//                                print("b")
//                            }) {
//                                Image(systemName: "plus.circle")
//                            }
//
//                        }
//                    }
                    
                }
            }
        }.sheet(isPresented: $openSheet) {
            ImagePicker()
                .onSelectFile {
                    image = $0
                }
        }.alert(isPresented: $alert) {
            Alert(title: Text("파일 오류"), message: Text("내부 파일이 잘못되었거나 오류가 있는 파일입니다."), dismissButton: .cancel())
        }
    }
}
