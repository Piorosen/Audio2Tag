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
            List {
                Section(header: Text("Meta")) {
                    ForEach (self.viewModel.metaData) { meta in
                        HStack {
                            Text(meta.value.key)
                            Spacer()
                            Text(meta.value.value)
                        }
                    }
                }
                Section(header: Text("Rem")) {
                    ForEach (self.viewModel.remData) { meta in
                        HStack {
                            Text(meta.value.key)
                            Spacer()
                            Text(meta.value.value)
                        }
                    }
                }
                Section(header: Text("File")) {
                    Text(self.viewModel.fileName)
                    ForEach (self.viewModel.track) { track in
                        Text(track.track.title)
                    }
                }
                
            }
            .navigationBarTitle("Tracks")
            .navigationBarItems(leading: Group {
                Button(action: self.viewModel.testMakeItem) {
                    Text("Make")
                }
            }, trailing: Group {
                Button(action: self.viewModel.addItem) {
                    Text("+")
                }
            })
            .sheet(isPresented: self.$viewModel.isDocumentShow) {
                DocumentPicker().onSelectFile { url in
                    self.viewModel.loadItem(url: url)
                }
            }
        }
    }
}

struct CueView_Previews: PreviewProvider {
    static var previews: some View {
        CueView()
    }
}
