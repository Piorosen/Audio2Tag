//
//  CueViewModel.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/06/19.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import Foundation
import CueSheet
import Cocoa
import AVFoundation


public final class AVAudioFileConverter {
    var rwAudioSerializationQueue: DispatchQueue!
    var asset:AVAsset!
    var assetReader:AVAssetReader!
    var assetReaderAudioOutput:AVAssetReaderTrackOutput!
    var assetWriter:AVAssetWriter!
    var assetWriterAudioInput:AVAssetWriterInput!
    var outputURL:[(url:URL, range:CMTimeRange)]
    var inputURL:URL
    
    public init?(inputFileURL: URL, outputFileURL: [(url:URL, range:CMTimeRange)]) {
        inputURL = inputFileURL
        outputURL = outputFileURL
        
    }
    
    public func convert() {
        let rwAudioSerializationQueueDescription = " rw audio serialization queue"
        // Create the serialization queue to use for reading and writing the audio data.
        rwAudioSerializationQueue = DispatchQueue(label: rwAudioSerializationQueueDescription)
        assert(rwAudioSerializationQueue != nil, "Failed to initialize Dispatch Queue")
        
        asset = AVAsset(url: inputURL)
        assert(asset != nil, "Error creating AVAsset from input URL")
        //    print("Output file path -> ", outputURL.absoluteString)
        
        asset.loadValuesAsynchronously(forKeys: ["tracks"], completionHandler: {
            var success = true
            var localError:NSError?
            success = (self.asset.statusOfValue(forKey: "tracks", error: &localError) == AVKeyValueStatus.loaded)
            // Check for success of loading the assets tracks.
            if (success) {
                // If the tracks loaded successfully, make sure that no file exists at the output path for the asset writer.
                let fm = FileManager.default
                //        let localOutputPath = self.outputURL.path
                //        if (fm.fileExists(atPath: localOutputPath)) {
                //          do {
                //            try fm.removeItem(atPath: localOutputPath)
                //            success = true
                //          } catch {
                //            print("Error trying to remove output file at path -> \(localOutputPath)")
                //          }
                //        }
            }
            
            for i in self.outputURL {
                if (success) {
                    success = self.setupAssetReaderAndAssetWriter(url: i.url)
                }
                if (success) {
                    success = self.startAssetReaderAndWriter(range: i.range)
                    
                } else {
                    print("Failed to start Asset Reader and Writer")
                }
                sleep(1)
            }
            
            
        })
    }
    
    func setupAssetReaderAndAssetWriter(url:URL) -> Bool {
        do {
            assetReader = try AVAssetReader(asset: asset)
        } catch {
            print("Error Creating AVAssetReader")
        }
        
        do {
            assetWriter = try AVAssetWriter(outputURL: url, fileType: AVFileType.wav)
        } catch {
            print("Error Creating AVAssetWriter")
        }
        
        var assetAudioTrack:AVAssetTrack? = nil
        let audioTracks = asset.tracks(withMediaType: AVMediaType.audio)
        
        if (audioTracks.count > 0) {
            assetAudioTrack = audioTracks[0]
        }
        
        if (assetAudioTrack != nil) {
            
            let decompressionAudioSettings:[String : Any] = [
                AVFormatIDKey:Int(kAudioFormatLinearPCM)
            ]
            
            assetReaderAudioOutput = AVAssetReaderTrackOutput(track: assetAudioTrack!, outputSettings: decompressionAudioSettings)
            assert(assetReaderAudioOutput != nil, "Failed to initialize AVAssetReaderTrackOutout")
            assetReader.add(assetReaderAudioOutput)
            
            var channelLayout = AudioChannelLayout()
            memset(&channelLayout, 0, MemoryLayout<AudioChannelLayout>.size);
            channelLayout.mChannelLayoutTag = kAudioChannelLayoutTag_Stereo;
            
            let outputSettings:[String : Any] = [
                AVFormatIDKey: Int(kAudioFormatLinearPCM),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVChannelLayoutKey: NSData(bytes:&channelLayout, length:  MemoryLayout.size(ofValue: AudioChannelLayout.self)),
                AVLinearPCMBitDepthKey: 16,
                AVLinearPCMIsNonInterleaved: false,
                AVLinearPCMIsFloatKey: false,
                AVLinearPCMIsBigEndianKey: false,
                
            ]
            
            assetWriterAudioInput = AVAssetWriterInput(mediaType: AVMediaType.audio, outputSettings: outputSettings)
            assert(rwAudioSerializationQueue != nil, "Failed to initialize AVAssetWriterInput")
            assetWriter.add(assetWriterAudioInput)
            
        }
        print("Finsihed Setup of AVAssetReader and AVAssetWriter")
        return true
    }
    
    func startAssetReaderAndWriter(range: CMTimeRange) -> Bool {
        print("STARTING ASSET WRITER")
        
        assetReader.timeRange = range
        
        assetWriter.startWriting()
        assetReader.startReading()
        assetWriter.startSession(atSourceTime: CMTime.zero)
        //    assetWriter.endSession(atSourceTime: CMTime(seconds: 1000, preferredTimescale: 1))
        //    assetWriter.endSession(atSourceTime: CMTime(seconds: 100, preferredTimescale: 1))
        
        assetWriterAudioInput.requestMediaDataWhenReady(on: rwAudioSerializationQueue, using: {
            
            while(self.assetWriterAudioInput.isReadyForMoreMediaData ) {
                var sampleBuffer = self.assetReaderAudioOutput.copyNextSampleBuffer()
                if(sampleBuffer != nil) {
                    self.assetWriterAudioInput.append(sampleBuffer!)
                    sampleBuffer = nil
                } else {
                    self.assetWriterAudioInput.markAsFinished()
                    self.assetReader.cancelReading()
                    self.assetWriter.finishWriting {
                        print("Asset Writer Finished Writing")
                    }
                    break
                }
            }
        })
        return true
    }
}

struct CueViewInfoModel {
    var albumName:String = "None"
    var barcode:String = "None"
    var avgBitrate: Double = 0
    var genre: String = "None"
}

class CueViewModel : ObservableObject {
    @Published var cueTitle = CueViewInfoModel()
    @Published var listOfCue = [CueModel]()
    
    func showNotification() -> Void {
        var notification = NSUserNotification()
        notification.title = "Test from Swift"
        notification.informativeText = "The body of this Swift notification"
        notification.soundName = NSUserNotificationDefaultSoundName
//        NSUserNotificationCenter.default.deliverNotification(notification)
        NSUserNotificationCenter.default.deliver(notification)
    }
    
    func onParsingFile(url:URL?) {
        let parser = CueSheetParser()
        if let list = parser.Load(path: url) {
            self.listOfCue.removeAll()
            let name = url!.deletingLastPathComponent().appendingPathComponent(list.file.fileName)
            let fileLength = AVURLAsset(url: name).duration
            
            for index in list.file.tracks.indices {
                var dur = 0.0
                let lastIndex = list.file.tracks[index].index.count - 1
                
                if index != list.file.tracks.count - 1 {
                    let me = list.file.tracks[index].index[lastIndex].indexTime.frames
                    let next = list.file.tracks[index + 1].index[0].indexTime.frames
                    
                    dur = Double((next - me)) / 75
                }else {
                    let me = list.file.tracks[index].index[lastIndex].indexTime.seconds
                    
                    dur = CMTimeGetSeconds(fileLength) - (me)
                }
                
                var interval = 0.0
                
                if list.file.tracks[index].index.count != 0 {
                    let shortCut = list.file.tracks[index].index
                    interval = Double(shortCut.last!.indexTime.frames - shortCut.first!.indexTime.frames) / 75
                }
                
                DispatchQueue.main.async {
                    self.listOfCue.append(CueModel(fileName: list.file.tracks[index].title, artist: list.file.tracks[index].performer, duration: dur, interval: interval))
                }
            }
        }
    }
    
    func onOpenFile() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.begin { (result) -> Void in
            if result == .OK {
                self.onParsingFile(url: panel.url)
            }
        }
        
    }
    
    func onTest(result:[(url:URL, range:CMTimeRange)]) {
        let origin = URL(fileURLWithPath: "/Users/aoikazto/Desktop/MYTH&ROID - HYDRA.wav")
        //        let result = [URL(fileURLWithPath: "/Users/aoikazto/Desktop/1.wav"),
        //                      URL(fileURLWithPath: "/Users/aoikazto/Desktop/2.wav"),
        //                      URL(fileURLWithPath: "/Users/aoikazto/Desktop/3.wav"),
        //                      URL(fileURLWithPath: "/Users/aoikazto/Desktop/4.wav")]
        
        if let p = AVAudioFileConverter(inputFileURL: origin, outputFileURL: result) {
            p.convert()
        }
    }
    
    func onSplitFile() {
    
    }
}

