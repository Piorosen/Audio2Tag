//
//  TagFileDetailListView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/28.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI
import ID3TagEditor

struct TagFileDetailListView: View {
    @ObservedObject var viewModel = TagFileDetailListViewModel()
    
    
    var body: some View {
        List {
            Group {
                GeometryReader { (g:GeometryProxy) in
                    ZStack {
                        Image(uiImage: viewModel.frontImage)
                            .resizable()
                            .frame(width: g.size.width, height: g.size.height, alignment: .center)
                            .aspectRatio(contentMode: .fill)
                            .blur(radius: 15)
                            .colorInvert()
                        
                        Image(uiImage: viewModel.frontImage)
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
            }.frame(maxWidth: .infinity, idealHeight: 200, alignment: .center)
            
            Divider().padding(.all, 10)
            
            Section {
                ForEach(viewModel.text.indices, id: \.self) { idx in
                    NavigationLink(destination: EmptyView()) {
                        HStack {
                            Text("\(viewModel.text[idx].title)")
                            Spacer()
                            TextField("", text: $viewModel.text[idx].text)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                    
                }.onDelete(perform: { idx in
                    viewModel.text.remove(atOffsets: idx)
                })
            }
        }
        .navigationTitle("Detail View")
        .navigationBarItems(trailing: EditButton())
    }
}
