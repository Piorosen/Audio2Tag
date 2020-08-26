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
            VStack {
   
            }
            .navigationTitle("Tag Info")
            .navigationBarItems(trailing: TagNavigationTraillingView().onTagReuqest {
                viewModel.openSheet = true
            })
        }
        .sheet(isPresented: $viewModel.openSheet) {
            TagSearchView().setKind(kind: .VgmDB)
//                        DocumentPicker()
//                            .setConfig(folderPicker: false, allowMultiple: false)
//                            .setUTType(type: [.folder])
//                            .onSelectFile { viewModel.loadAudio(url: $0) }
        }.actionSheet(isPresented: $viewModel.openActionSheet) {
            ActionSheet(title: Text("검색"), message: Text("Tag 정보를 검색합니다."), buttons: [
                .default(Text("VgmDB")) { },
                .default(Text("MusicBrainz")) { },
                .cancel()
            ])
        }
    }
}

struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        TagView()
    }
}
