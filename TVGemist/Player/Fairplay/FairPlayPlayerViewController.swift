//
//  FairPlayPlayerViewController.swift
//  NPO
//
//  Created by Jeroen Wesbeek on 28/11/2017.
//  Copyright © 2017 Jeroen Wesbeek. All rights reserved.
//

import UIKit
import AVKit
import XCGLogger
import NPOKit

class FairPlayPlayerViewController: AVPlayerViewController {
//    private var stream: Stream?
    
    // MARK: Playing
    
    func play(playlist: LegacyPlaylist) {
        let url = playlist.url
//    }
//
//    func play(videoStream stream: Stream) {
//        self.stream = stream
//        
//        let url = stream.url
//        let url = URL(string: "cplp://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8")!
        
        let asset = AVURLAsset(url: url, options: nil)
//        let queue = DispatchQueue(label: "eu.osx.tvos.NPO.assetqueue")
//        asset.resourceLoader.setDelegate(self, queue: queue)
        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: playerItem)
        player.actionAtItemEnd = .pause
        player.automaticallyWaitsToMinimizeStalling = true
        
        self.player = player
        
//        DDLogDebug("playing \(stream.url)")
        
        self.player?.play()
    }
}

//extension FairPlayPlayerViewController: AVAssetResourceLoaderDelegate {
//    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
//        // 1. Generate the SPC
//        //      - handle shouldWaitForLoadingOfRequestResource: for key requests
//        //      - call [AVAssetResourceLoadingRequest streamingContentKeyRequestDataForApp: contentIdentifier: options: err: ] to produce SPC
//        // 2. Send SPC request to your Key Server
//        // 3. Provide CKC response (or error) to AVAssetResourceLoadingRequest
//
//        guard let stream = stream else {
//            log.error("🔑 Missing stream")
//            loadingRequest.finishLoading(with: NSError(domain: "eu.osx.tvos.NPO.error", code: -1, userInfo: nil))
//            return false
//        }
//
//        // check if the url is set in the manifest
//        guard let url = loadingRequest.request.url else {
//            log.error("🔑 Unable to read the URL/HOST data")
//            loadingRequest.finishLoading(with: NSError(domain: "eu.osx.tvos.NPO.error", code: -2, userInfo: nil))
//            return false
//        }
//
//        log.debug("🔑 url: \(url)")
//
//        // load the certificate from the server
//        guard let certificateURL = stream.certificateURL, let certificateData = try? Data(contentsOf: certificateURL) else {
//            log.error("🔑 Unable to read the certificate data")
//            loadingRequest.finishLoading(with: NSError(domain: "eu.osx.tvos.NPO.error", code: -3, userInfo: nil))
//            return false
//        }
//
//        log.debug("🔑 certificate: \(certificateData)")
//
////        #EXTM3U
////        #EXT-X-VERSION:5
////        ## Created with Unified Streaming Platform(version=1.7.18)
////        #EXT-X-MEDIA-SEQUENCE:0
////        #EXT-X-PLAYLIST-TYPE:VOD
////        #EXT-X-INDEPENDENT-SEGMENTS
////        #EXT-X-TARGETDURATION:8
////        #EXT-X-KEY:METHOD=SAMPLE-AES,URI="skd://5dc60e94-a10c-1822-7b0c-914773242c94",KEYFORMAT="com.apple.streamingkeydelivery",KEYFORMATVERSIONS="1"
////        #EXTINF:8, no desc
//
//        // see https://icapps.com/blog/how-integrate-basic-hls-stream-fairplay-0
//        // see https://gist.github.com/fousa/5709fb7c84e5b53dbdae508c9cb4fadc
//        // see https://github.com/streamlink/streamlink/issues/1062
//        // see https://developer.apple.com/streaming/
//        // see https://forums.developer.apple.com/community/media/http-live-streaming
//
//        // widevine player cert
//        // https://npo-drm-gateway.samgcloud.nepworldwide.nl/widevine_player_cert.bin
//        // Fairplay CERT
//        // https://s3-eu-west-1.amazonaws.com/24i-npo-stream/fairplay.cer
//
//        // request the Server Playback Context (SPC)
//        guard
////            let contentIdData = "com.apple.fps.1_0".data(using: .utf8),
////            let contentIdData = stream.licenseToken.data(using: .utf8),
////            let contentIdData = "com.apple.streamingkeydelivery".data(using: .utf8),
//            let host = loadingRequest.request.url?.host,
//            let contentIdentifierData = host.data(using: .utf8),
//            let spcData = try? loadingRequest.streamingContentKeyRequestData(forApp: certificateData, contentIdentifier: contentIdentifierData, options: nil),
//            let dataRequest = loadingRequest.dataRequest else {
//                log.error("🔑 Unable to read the SPC data")
//                loadingRequest.finishLoading(with: NSError(domain: "eu.osx.tvos.NPO.error", code: -4, userInfo: nil))
//                return false
//        }
//
////        guard
////            loadingRequest.request.url?.scheme == "skd",
////            let serverPlaybackContext = try? loadingRequest.streamingContentKeyRequestData(forApp: certificateData, contentIdentifier: contentIdentifierData, options: [AVAssetResourceLoadingRequestStreamingContentKeyRequestRequiresPersistentKey: true]),
////            let persistentContentKeyContext = loadingRequest.persistentContentKey(fromKeyVendorResponse: ckc, options: nil, error: nil) else {
////            DDLogError("🔑 Unable to read the SPC data")
////            loadingRequest.finishLoading(with: NSError(domain: "eu.osx.tvos.NPO.error", code: -4, userInfo: nil))
////            return false
////        }
//
//        log.debug("🔑 request: \(loadingRequest)")
//        log.debug("🔑 host: \(host)")
//        log.debug("🔑 spcData: \(spcData)")
//        log.debug("🔑 spcData: \(String(describing: String(data: spcData, encoding: .utf8)))")
//        log.debug("🔑 spcData: \(spcData.base64EncodedString())")
//
//        // request the content key context from the server
//        var request = URLRequest(url: stream.licenseServer)
//        request.httpMethod = "POST"
//        request.httpBody = spcData
//        let session = URLSession(configuration: .default)
////        let task = session.dataTask(with: request) { data, response, error in}
//        let task = session.dataTask(with: request) { (data, response, error) in
//            log.debug("response: \(String(describing: response))")
//            log.debug("data: \(String(describing: data))")
//            log.debug("error: \(String(describing: error?.localizedDescription))")
//
//            if let data = data {
//                // The CKC is correctly returned and is now send to the `AVPlayer` instance so we
//                // can continue to play the stream.
//                log.debug("🔑 OK!")
//                log.debug("data: \(String(describing: String(data: data, encoding: .utf8)))")
//                log.debug("data base64: \(data.base64EncodedString())")
//                dataRequest.respond(with: data)
//                loadingRequest.finishLoading()
//            } else {
//                log.error("🔑 Unable to fetch the CKC")
//                loadingRequest.finishLoading(with: NSError(domain: "eu.osx.tvos.NPO.error", code: -5, userInfo: nil))
//            }
//        }
//        task.resume()
//
//        // tell the AVPlayer instance to wait
//        return true
//    }
//}
