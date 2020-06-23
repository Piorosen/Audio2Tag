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
    @State var progress:Float = 0.2
    
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
                ProgressBar(value: self.$progress)
                Button(action: {
                    
                    
                }) {
                    Text("Cue Open")
                }
                Button(action: {
                    
                    
                }) {
                    Text("Cue Open")
                }
                
            }.frame(maxWidth: .infinity, maxHeight: 10)
                .padding(10)
            
            
            List (self.viewModel.listOfCue) { item in
                HStack {
                    VStack {
                        Text("Title \(item.fileName)")
                        Text("Artist \(item.artist)")
                    }
                    Spacer()
                    Text("Length of Music : \(item.duration)")
                    Text("Length of Index : \(item.interval)")
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
        .onDrop(of: [kUTTypeFileURL as String], isTargeted: nil) { itemProvider in
            for item in itemProvider {
                item.loadItem(forTypeIdentifier: (kUTTypeFileURL as String), options: nil) {item, error in
                    guard let data = item as? Data, let url = URL(dataRepresentation: data, relativeTo: nil) else { return }
                    
                    self.viewModel.onParsingFile(url: url)
                    
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
