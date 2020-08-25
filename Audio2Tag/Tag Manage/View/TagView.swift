//
//  TagView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/10.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct TagView: View {
    @ObservedObject var viewModel = TagViewModel()
    
    var body: some View {
        NavigationView{
            // Image
            LazyVStack {
                Image(uiImage: viewModel.tagInfo.image)
                Divider()
                Section(header: Text("description")) {
                    ForEach(self.viewModel.tagInfo.tagFrame) { value in
                        NavigationLink(destination: EmptyView()) {
                            HStack {
//                                Text("\(value.key.hashValue)")
                                Spacer()
                                Text("\("하하")")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Tag Info")
            .navigationBarItems(trailing: Group {
                Button(action: viewModel.traillingButtonAction) {
                    Image(systemName: "plus.app")
                }
            })
        }.sheet(isPresented: $viewModel.openSheet) {
            DocumentPicker()
                .setConfig(folderPicker: false, allowMultiple: false)
                .onSelectFile { viewModel.loadAudio(url: $0) }
        }
    }
}

struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        TagView()
    }
}
