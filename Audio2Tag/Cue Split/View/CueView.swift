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
                
                Text("평균 비트레이트 : \(String(format: "%.0f", self.viewModel.cueTitle.avgBitrate))")
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
                CueItemView(item: item)
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
//            .onDrop(of: [kUTTypeFileURL as String], isTargeted: nil) { itemProvider in
//                var urls = [URL]()
//                
//                for item in itemProvider {
//                    let delay = DispatchSemaphore(value: 0)
//                    item.loadItem(forTypeIdentifier: (kUTTypeFileURL as String), options: nil) { item, error in
//                        if let data = item as? Data, let url = URL(dataRepresentation: data, relativeTo: nil)  {
//                            urls.append(url)
//                            print(url)
//                        }
//                        
//                        delay.signal()
//                    }
//                    delay.wait(timeout: .now() + 0.5)
//                }
//                
//                print("breaked")
//                
//                
//                //            if urls.count == 2 {
//                //                if let item = urls.firstIndex(where: { $0.pathExtension.lowercased() == "cue" }) {
//                //                    self.viewModel.onParsingFile(url: urls[item], music: urls[item == 0 ? 1 : 0])
//                //                }
//                //            }else if urls.count == 1 {
//                //                if let item = urls.first(where: { $0.pathExtension.lowercased() == "cue" }) {
//                //                    self.viewModel.onParsingFile(url: item, music: nil)
//                //                }
//                //            }
//                //
//                return true
//        }
    }
}

struct CueView_Previews: PreviewProvider {
    static var previews: some View {
        CueView()
    }
}
