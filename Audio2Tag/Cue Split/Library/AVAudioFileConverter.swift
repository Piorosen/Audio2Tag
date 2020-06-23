//
//  File.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/06/23.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import Foundation
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
            var localError:NSError?
            let success = (self.asset.statusOfValue(forKey: "tracks", error: &localError) == AVKeyValueStatus.loaded)
            // Check for success of loading the assets tracks.
            
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
