//
//  CueAudioView.swift
//  Audio2Tag
//
//  Created by aoikazto on 2021/05/28.
//

import SwiftUI
import AVFoundation
import SwiftCueSheet

struct AudioFilesModel : Identifiable, Equatable {
    let id: UUID = UUID()
    
    init(url: URL) {
        self.url = url
        self.image = nil
        self.title = url.lastPathComponent
        self.player = try! AVAudioPlayer(contentsOf: url)
        
        for item in AVAsset(url: url).commonMetadata {
            if item.commonKey == .commonKeyArtwork {
                image = item.dataValue
            }
            else if item.commonKey == .commonKeyTitle {
                title = item.stringValue ?? title
            }
        }
    }
    public var url: URL
    public var image: Data?
    public var title: String
    
    public var player: AVAudioPlayer
}

class CueAudioViewModel : NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Binding var audio: AudioFilesModel?
    @Published var play = false
    var currentTime = CSIndexTime(time: 0)
    var endTime = CSIndexTime(time: 0)
    @Published var percent: Double = 0
    
    func update() {
        guard let p = audio?.player else {
            currentTime = CSIndexTime(time: 0)
            endTime = CSIndexTime(time: 0)
            return
        }
        if audio?.player.delegate == nil {
            audio?.player.delegate = self
        }
        
        currentTime = CSIndexTime(time: p.currentTime)
        endTime = CSIndexTime(time: p.duration)
        if endTime.frames != 0 {
            percent = currentTime.totalSeconds / endTime.totalSeconds
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
                            Text(self.viewModel.endTime.description)
                        }
                    }
                    
                    HStack(alignment: .center) {
                        Spacer()
                        Button(action: {
                            viewModel.audio?.player.currentTime -= 15
                        }) {
                            Image(systemName: "gobackward.15").padding(20)
                        }
                        Button(action: {
                            if let b = viewModel.audio?.player, b.isPlaying {
                                viewModel.audio?.player.stop()
                                viewModel.play = false
                            }else {
                                viewModel.audio?.player.play()
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
                            viewModel.audio?.player.currentTime += 15
                        }) {
                            Image(systemName: "goforward.15").padding(20)
                        }
                        Spacer()
                    }.buttonStyle(BorderlessButtonStyle())
                }
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: 0.16, repeats: true) { timer in
                        viewModel.update()
                    }
                }
                
                Button(action: {
                    viewModel.audio?.player.stop()
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

