//
//  CueFileInfoView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/21.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI
import CoreMedia

struct CueFileInfoView: View {
    @Binding var fileInfo: CueSheetModel
    
    
    func musicInfo() -> AnyView {
        guard let info = fileInfo.cueSheet?.info else {
            return AnyView(EmptyView())
        }
        if fileInfo.musicUrl == nil {
            return AnyView(EmptyView())
        }
        
        
        return AnyView(Section(header: Text("Music")) {
            HStack {
                Text("음원 길이")
                Spacer()
                Text("\(CueDetailTrackViewModel.makeTime(CMTimeGetSeconds(info.lengthOfAudio)))")
            }
            HStack {
                Text("채널 수")
                Spacer()
                Text("\(info.format.channelCount)")
            }
            HStack {
                Text("샘플 레이트")
                Spacer()
                Text("\(Int(info.format.sampleRate))")
            }
        })
        
        
    }
    
    var body: some View {
        List {
            musicInfo()
            Section(header: Text("Meta")) {
                ForEach (self.fileInfo.rem) { meta in
                    HStack {
                        Text(meta.value.key)
                        Spacer()
                        Text(meta.value.value)
                    }
                }
            }
            Section(header: Text("Rem")) {
                ForEach (self.fileInfo.meta) { meta in
                    HStack {
                        Text(meta.value.key)
                        Spacer()
                        Text(meta.value.value)
                    }
                }
            }
            Section(header: Text("File : \(self.fileInfo.cueSheet?.file.fileName ?? String())")) {
                ForEach (self.fileInfo.tracks) { track in
                    NavigationLink(destination: CueDetailTrackView(track)) {
                        Text("\(track.track.trackNum) : \(track.track.title)")
                    }
                }
            }
        }
    }
}
