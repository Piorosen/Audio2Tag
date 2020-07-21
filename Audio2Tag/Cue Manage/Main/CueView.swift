//
//  CueView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/10.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct CueView: View {
    @ObservedObject var viewModel = CueViewModel()
    
    var body: some View {
        
        NavigationView {
            CueFileInfoView(fileInfo: self.$viewModel.cueFileInfo)
                .sheet(isPresented: self.$viewModel.openSheet) {
                    DocumentPicker(isFolderPicker: true)
                     .onSelectFile { url in
                         self.viewModel.splitStart(url: url)
                    }
//                    DocumentPicker(isFolderPicker: false)
//                    .onSelectFiles { urls in
//                        self.viewModel.loadItem(url: urls)
//                    }
            }.alert(isPresented: self.$viewModel.openAlert) { Alert(title: Text("haha")) }
            .navigationBarTitle("Cue Info")
            .navigationBarItems(leading: Group {
                Button(action: self.viewModel.openAlertSplitView) {
                    Text("Make")
                }
            }, trailing: Group {
                Button(action: self.viewModel.openCueSearchDocument) {
                    Image(systemName: "plus")
                }
                .padding(10)
            })
            
        }
    }
}

struct CueView_Previews: PreviewProvider {
    static var previews: some View {
        CueView()
    }
}
