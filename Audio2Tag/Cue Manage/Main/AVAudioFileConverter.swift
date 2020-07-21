//
//  AVAudioFileConverter.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/20.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import Foundation
import AVFoundation

public final class AVAudioFileConverter {
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
    
    public func convert(callback: @escaping (Float) -> Void, completeHandler:  @escaping () -> Void) {
        
//        let rwAudioSerializationQueueDescription = " rw audio serialization queue"
        // Create the serialization queue to use for reading and writing the audio data.
        
        
        asset = AVAsset(url: inputURL)
        assert(asset != nil, "Error creating AVAsset from input URL")
        //    print("Output file path -> ", outputURL.absoluteString)
        
        asset.loadValuesAsynchronously(forKeys: ["tracks"]) {
            var localError:NSError?
            var success = (self.asset.statusOfValue(forKey: "tracks", error: &localError) == AVKeyValueStatus.loaded)
            // Check for success of loading the assets tracks.
            
            for i in self.outputURL.indices {
                if (success) {
                    success = self.setupAssetReaderAndAssetWriter(url: self.outputURL[i].url)
                }
                
                if (success) {
                    success = self.startAssetReaderAndWriter(range: self.outputURL[i].range) { p in
                        let index = Float(i) / Float(self.outputURL.count)
                        let size = Float(1) / Float(self.outputURL.count) * p
                        callback(index + size)
                    }
                    
                } else {
                    print("Failed to start Asset Reader and Writer")
                }
            }
            completeHandler()
        }
        
        print("finished")
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
            guard let file = try? AVAudioFile(forReading: inputURL) else {
                return false
            }
            let outputSettings = file.fileFormat.settings
            
            let decompressionAudioSettings:[String : Any] = [
                AVFormatIDKey:Int(kAudioFormatLinearPCM)
            ]
            
            assetReaderAudioOutput = AVAssetReaderTrackOutput(track: assetAudioTrack!, outputSettings: decompressionAudioSettings)
            assert(assetReaderAudioOutput != nil, "Failed to initialize AVAssetReaderTrackOutout")
            assetReader.add(assetReaderAudioOutput)
            
//            var channelLayout = AudioChannelLayout()
//            memset(&channelLayout, 0, MemoryLayout<AudioChannelLayout>.size);
//            channelLayout.mChannelLayoutTag = kAudioChannelLayoutTag_Stereo;
            
            
            
//            let outputSettings:[String : Any] = [
//                AVFormatIDKey: Int(kAudioFormatLinearPCM),
//                AVSampleRateKey: file.fileFormat.sampleRate,
//                AVNumberOfChannelsKey: file.fileFormat.channelCount,
//                AVChannelLayoutKey: NSData(bytes:&channelLayout, length:  MemoryLayout.size(ofValue: AudioChannelLayout.self)),
//                AVLinearPCMBitDepthKey: ,
//                AVLinearPCMIsNonInterleaved: false,
//                AVLinearPCMIsFloatKey: false,
//                AVLinearPCMIsBigEndianKey: false,
//
//            ]
            
            assetWriterAudioInput = AVAssetWriterInput(mediaType: AVMediaType.audio, outputSettings: outputSettings)
            
            assetWriter.add(assetWriterAudioInput)
            
        }
        print("Finsihed Setup of AVAssetReader and AVAssetWriter")
        return true
    }
    
    func startAssetReaderAndWriter(range: CMTimeRange, percentCallback: @escaping (Float) -> Void) -> Bool {
        let delay = DispatchSemaphore(value: 0)
        print("STARTING ASSET WRITER")
        
        assetReader.timeRange = range
        
        assetWriter.startWriting()
        assetReader.startReading()
        assetWriter.startSession(atSourceTime: CMTime.zero)
        //    assetWriter.endSession(atSourceTime: CMTime(seconds: 1000, preferredTimescale: 1))
        //    assetWriter.endSession(atSourceTime: CMTime(seconds: 100, preferredTimescale: 1))
        
        assetWriterAudioInput.requestMediaDataWhenReady(on: DispatchQueue(label: "gogogo")) {
            while(self.assetWriterAudioInput.isReadyForMoreMediaData ) {
                var sampleBuffer = self.assetReaderAudioOutput.copyNextSampleBuffer()
                
                if(sampleBuffer != nil) {
                    let timeStamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer!)
                    let timeSecond = CMTimeGetSeconds(timeStamp - range.start)
                    
                    let per = timeSecond / CMTimeGetSeconds(range.duration)
                    percentCallback(Float(per))
                    
                    self.assetWriterAudioInput.append(sampleBuffer!)
                    sampleBuffer = nil
                } else {
                    self.assetWriterAudioInput.markAsFinished()
                    self.assetReader.cancelReading()
                    self.assetWriter.finishWriting {
                        delay.signal()
                        print("Asset Writer Finished Writing")
                    }
                    break
                }
            }
            
            percentCallback(1)
        }
        
        delay.wait()
        return true
    }
}