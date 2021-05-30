//
//  CueAudioView.swift
//  Audio2Tag
//
//  Created by aoikazto on 2021/05/28.
//

import SwiftUI
import AVFoundation

struct AudioFilesModel : Identifiable {
    let id: UUID = UUID()
    
    init(url: URL) {
        self.url = url
        self.image = nil
        self.title = url.lastPathComponent
        
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
}

class CueAudioViewModel : ObservableObject {
    @Binding var audio: AudioFilesModel?
    @Published var playDuration: TimeInterval = 0
    @Published var play = false
    
    
    
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
                        ProgressView("", value: self.viewModel.playDuration)
                    }
                    
                    HStack(alignment: .center) {
                        Spacer()
                        Button(action: {
                            viewModel.player.currentTime -= 15
                        }) {
                            Image(systemName: "gobackward.15").padding(20)
                        }
                        Button(action: {
                            if viewModel.player.isPlaying {
                                viewModel.player.stop()
                                viewModel.play = false
                            }else {
                                viewModel.player.play()
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
                            viewModel.player.currentTime += 15
                        }) {
                            Image(systemName: "goforward.15").padding(20)
                        }
                        Spacer()
                    }.buttonStyle(BorderlessButtonStyle())
                }
                
                
                
                Button(action: discardEvent, label: {
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

