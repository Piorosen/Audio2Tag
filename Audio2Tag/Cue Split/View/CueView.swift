//
//  CueView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/06/19.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct CueView: View {
    @ObservedObject var viewModel = CueViewModel()
    
    
    var body: some View {
        VStack {
            HStack (alignment: .center) {
                Spacer()
                Text("앨범 명 : \(self.viewModel.cueTitle.albumName)").bold()
                Spacer()
                Text("바코드 : \(self.viewModel.cueTitle.barcode)")
                Spacer()
                
                Text("평균 비트레이트 : \(self.viewModel.cueTitle.avgBitrate)")
                Spacer()
                Text("장르 : \(self.viewModel.cueTitle.genre)")
                Spacer()
            }.frame(maxWidth: .infinity, minHeight: 30)
            HStack {
                ProgressBar(value: self.$viewModel.progress)
                Button(action: {
                    self.viewModel.onOpenFile()
                }) {
                    Text("Cue Open")
                }
                Button(action: {
                    self.viewModel.onSplitFile()
                    
                }) {
                    Text("Cue Split")
                }
                
            }.frame(maxWidth: .infinity, maxHeight: 10)
                .padding(10)
            
            List (self.viewModel.listOfCue) { item in
                HStack {
                    Text("\(item.index)")
                    VStack {
                        Text("Title \(item.fileName)")
                        Text("Artist \(item.artist)")
                    }
                    Spacer()
                    Text("Length of Music : \(String(format: "%.2f 초", item.duration))")
                    Text("Length of Index : \(String(format: "%.2f 초", item.interval))")
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
        .onDrop(of: [kUTTypeFileURL as String], isTargeted: nil) { itemProvider in
            for item in itemProvider {
                item.loadItem(forTypeIdentifier: (kUTTypeFileURL as String), options: nil) {item, error in
                    guard let data = item as? Data, let url = URL(dataRepresentation: data, relativeTo: nil) else { return }
                    
                    
                    print(url.path)
                }
            }
            return true
        }
    }
}

struct CueView_Previews: PreviewProvider {
    static var previews: some View {
        CueView()
    }
}
