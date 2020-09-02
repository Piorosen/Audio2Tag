//
//  TagFileDetailListView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/28.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI
import ID3TagEditor

extension View {
    ////    func sheet<Content>(isPresented: Binding<Bool>, ) -> some View where Content : View
    //    func customAlert<Content>(isPresent:Binding<Bool>, onDismiss: @escaping () -> Void, @ViewBuilder content: @escaping () -> Content) -> some View where Content : View {
    //        CustomAlertView(isPresent: isPresent, parent: self, content: content)
    //    }
}

struct TagFileDetailView: View {
    @ObservedObject var viewModel = TagFileDetailViewModel()
    
    var body: some View {
        ZStack {
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
            .navigationBarItems(trailing: HStack {
                Button(action: {
                    viewModel.openCustomAlert = true
                }) {
                    Text("Tag")
                }
                EditButton()
            })
            .sheet(isPresented: $viewModel.openSheet) {
                TagFileDetailListSheetView()
            }
            
            CustomAlertView(isPresent: $viewModel.openCustomAlert) {
                VStack {
                    Text("추가 태그 선택").padding(.top, 15)
                    Divider()
                    List {
                        Section(header: Text("")) {
                            ForEach(viewModel.remainTag , id: \.self) { item in
                                Text("\(item)")
                            }
                        }
                    }.frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .edgesIgnoringSafeArea(.all)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .animation(.spring())
        }
        
    }
}
