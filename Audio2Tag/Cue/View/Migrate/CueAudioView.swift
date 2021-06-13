//
//  CueAudioView.swift
//  Audio2Tag
//
//  Created by aoikazto on 2021/05/28.
//

import SwiftUI
import AVFoundation
import SwiftCueSheet

struct AudioFilesModel : Identifiable {
    let id: UUID = UUID()
    
    init?(url: URL) {
        self.url = url
//        self.image = nil
//        self.title =
        do {
            self.player = try AVAudioPlayer(contentsOf: url)
        }catch {
            return nil
        }
        
        let list = AVAsset(url: url).commonMetadata
        
        image = list.first { $0.commonKey == .commonKeyArtwork }?.dataValue
        title = list.first { $0.commonKey == .commonKeyTitle }?.stringValue ?? url.lastPathComponent
        endTime = CSIndexTime(time: player.duration)
    }
    
    public let url: URL
    public let image: Data?
    public let title: String
    
    public let player: AVAudioPlayer
    public let endTime: CSIndexTime
}

class CueAudioViewModel : NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Binding var audio: AudioFilesModel?
    @Published var play = false
    @Published var currentTime = CSIndexTime(time: 0)
    
    @Published var percent: Double = 0
    
    func update() {
        guard let p = audio?.player else {
            currentTime = CSIndexTime(time: 0)
            return
        }
        if audio?.player.delegate == nil {
            audio?.player.delegate = self
        }
        
        currentTime = CSIndexTime(time: p.currentTime)
        if let a = audio, a.endTime.frames != 0 {
            percent = currentTime.totalSeconds / a.endTime.totalSeconds
        }
        
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        player.pause()
        play = false
    }

    init(audio: Binding<AudioFilesModel?>) {
        self._audio = audio
    }
}

struct CueAudioView: View {
    @ObservedObject var viewModel: CueAudioViewModel
    
    init(audio: Binding<AudioFilesModel?>) {
        viewModel = CueAudioViewModel(audio: audio)
    }
    
    let timer = Timer.publish(every: 0.16, on: .main, in: .common).autoconnect()
    
    var loadEvent: (() -> Void) = { }
    var discardEvent: (() -> Void) = { }
    
    func onLoad(_ action: @escaping () -> Void) -> CueAudioView {
        var copy = self
        copy.loadEvent = action
        return copy
    }
    
    func onDisacrd(_ action: @escaping () -> Void) -> CueAudioView {
        var copy = self
        copy.discardEvent = action
        return copy
    }
    
    var body: some View {
        Section(header: Text("Audio Files")) {
            if let audioItem = self.viewModel.audio {
                VStack {
                    if let image = audioItem.image, let uiimage = UIImage(data: image) {
                        Image(uiImage: uiimage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, idealHeight: 300)
                            .padding([.top, .leading, .trailing])
                    }
                    
                    HStack {
                        Text(audioItem.title)
                    }.padding()
                    
                    VStack {
                        ProgressView("", value: self.viewModel.percent)
                        HStack {
                            Text(self.viewModel.currentTime.description)
                            Spacer()
                            Text(audioItem.endTime.description)
                        }
                    }
                    
                    HStack(alignment: .center) {
                        Spacer()
                        Button(action: {
                            audioItem.player.currentTime -= 15
                        }) {
                            Image(systemName: "gobackward.15").padding(20)
                        }
                        Button(action: {
                            if audioItem.player.isPlaying {
                                audioItem.player.stop()
                                viewModel.play = false
                            }else {
                                audioItem.player.play()
                                viewModel.play = true
                            }
                        }) {
                            if viewModel.play {
                                Image(systemName: "pause.fill").padding(20)
                            }else {
                                Image(systemName: "play.fill").padding(20)
                            }
                        }
                        
                        Button(action: {
                            audioItem.player.currentTime += 15
                        }) {
                            Image(systemName: "goforward.15").padding(20)
                        }
                        Spacer()
                    }.buttonStyle(BorderlessButtonStyle())
                }
                .onReceive(timer) { t in
                    if viewModel.play {
                        viewModel.update()
                    }
                }
                
                Button(action: {
                    audioItem.player.stop()
                    discardEvent()
                }, label: {
                    Text("Discard")
                })
            } else {
                Button(action: loadEvent, label: {
                    Text("Load File")
                })
            }
        }
    }
}

