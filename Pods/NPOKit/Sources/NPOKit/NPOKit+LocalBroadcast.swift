//
//  NPOKit+LocalBroadcast.swift
//  NPOKitPackageDescription
//
//  Created by Jeroen Wesbeek on 27/03/2018.
//

import Foundation

public extension NPOKit {
    public func fetchRegionalBroadcasts(completionHandler: @escaping (Result<[LocalBroadcast]>) -> Void) {
        let broadcasts: [LocalBroadcast] = [
            LocalBroadcast(id: "AT5",
                           type: .regional,
                           name: "AT5",
                           logoName: "at5",
                           url: URL(string: "https://lb-at5-live.cdn.streamgate.nl/at5/video/at5.smil/playlist.m3u8"),
                           imageURL: URL(string: "https://at5.s3-eu-west-1.amazonaws.com/data/cache/2/basedata/pf_image/1983245676-768849ee.jpg")),
            LocalBroadcast(id: "OmroepBrabant",
                           type: .regional,
                           name: "Omroep Brabant",
                           logoName: "omroepBrabant",
                           url: URL(string: "https://d3slqp9xhts6qb.cloudfront.net/omroepbrabantTv/index.m3u8"),
                           imageURL: URL(string: "https://omroepbrabant.bbvms.com/mediaclip/1089488/pthumbnail/736/414.jpg")),
            LocalBroadcast(id: "OmroepDrenthe",
                           type: .regional,
                           name: "Omroep Drenthe",
                           logoName: "rtvDrenthe",
                           url: URL(string: "https://stream.rtvdrenthe.nl/tv/:tvstream1/playlist.m3u8"),
                           imageURL: URL(string: "https://feeds.rtvdrenthe.nl/jwplayer-background-default.jpg")),
            LocalBroadcast(id: "OmroepFlevoland",
                           type: .regional,
                           name: "Omroep Flevoland",
                           logoName: "omroepFlevoland",
                           url: URL(string: "https://lb-omroepflevoland-live.cdn.streamgate.nl/omroepflevoland/livestream1.mp4/playlist.m3u8"),
                           imageURL: URL(string: "https://www.omroepflevoland.nl/assets/assets/img/social/ogimage.jpg")),
            LocalBroadcast(id: "OmropFryslân",
                           type: .regional,
                           name: "Omrop Fryslân",
                           logoName: "omropFryslân",
                           url: URL(string: "https://live.wowza.kpnstreaming.nl/omropfryslanlive/OFstream04.smil/playlist.m3u8"),
                           imageURL: URL(string: "https://www.omropfryslan.nl/data/files/omrop-fryslan-tv-plaatje-1920x1080-v2.jpg")),
            LocalBroadcast(id: "omroepGelderland",
                           type: .regional,
                           name: "Omroep Gelderland",
                           logoName: "omroepGelderland",
                           url: URL(string: "https://web.omroepgelderland.nl/live/livetv.m3u8"),
                           imageURL: URL(string: "https://imgg.rgcdn.nl/779915d44f1e4d3e8c2fe8b0e35f9d7d/opener/Omroep-Gelderland-was-zaterdag-tijdelijk-niet-online-bereikbaar.jpg")),
            LocalBroadcast(id: "rtvNoord",
                           type: .regional,
                           name: "RTV Noord",
                           logoName: "rtvNoord",
                           url: URL(string: "https://livestreams.omroep.nl/live/npo/regionaal/rtvnoord/rtvnoord.isml/rtvnoord.m3u8"),
                           imageURL: URL(string: "https://stream.rtvnoord.nl/live-televisie.jpg")),
            LocalBroadcast(id: "LI_L1_716599",
                           type: .regional,
                           name: "L1 TV",
                           logoName: "l1mburg",
                           url: nil,
                           imageURL: URL(string: "https://l1.nl/img-cache/2018/03/L1NWS_Wouter.606cc87e.png")),
            LocalBroadcast(id: "tvNH",
                           type: .regional,
                           name: "TV Noord Holland",
                           logoName: "tvNH",
                           url: URL(string: "http://lb-nh-live.cdn.streamgate.nl:1935/nh/video/nh.smil/playlist.m3u8"),
                           imageURL: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTy9Wzjot4TxbVuJQmPh3z-W1twVpwCUMMJGkx49w5uuFMcB4_BxQ")),
            LocalBroadcast(id: "tvOost",
                           type: .regional,
                           name: "TV Oost",
                           logoName: "tvOost",
                           url: URL(string: "https://rrr.sz.xlcdn.com/?account=rtv_oost&file=tvoost&type=live&service=wowza&output=playlist.m3u8"),
                           imageURL: URL(string: "https://img.rtvoost.nl/TV_background.jpg")),
            LocalBroadcast(id: "tvRijnmond",
                           type: .regional,
                           name: "TV Rijnmond",
                           logoName: "tvRijnmond",
                           url: URL(string: "https://d3r4bk4fg0k2xi.cloudfront.net/rijnmondTv/index.m3u8"),
                           imageURL: URL(string: "https://content.rijnmond.nl/statische-streams/live-televisie.jpg")),
            LocalBroadcast(id: "LI_RTUT_449889",
                           type: .regional,
                           name: "RTV Utrecht",
                           logoName: "rtvUtrecht",
                           url: nil,
                           imageURL: URL(string: "https://i2.wp.com/www.desfeervanweleer.nl/wp-content/uploads/2018/02/Documentaire-bij-RTV-Utrecht.jpg?resize=953%2C536")),
            LocalBroadcast(id: "omroepZeeland",
                           type: .regional,
                           name: "Omroep Zeeland",
                           logoName: "omroepZeeland",
                           url: URL(string: "https://stream.zeelandnet.nl/live/omroepzeeland_tv_200k.sdp/playlist.m3u8"),
                           imageURL: URL(string: "https://imgz.rgcdn.nl/f85d4792d1c043479b0d807dc0a2e9a0/opener/1495028493.jpg")),
            LocalBroadcast(id: "omroepWest",
                           type: .regional,
                           name: "Omroep West",
                           logoName: "omroepWest",
                           url: URL(string: "https://d2dslh4sd7yvc1.cloudfront.net/live/omroepwest/ngrp:tv-feed_all/playlist.m3u8"),
                           imageURL: URL(string: "https://imgw.rgcdn.nl/149806bfd2ac456fbc3b1bd8dab71b00/opener/Omroep-West.jpg"))
        ]
        
        completionHandler(.success(broadcasts))
    }
    
    public func fetchLocalBroadcasts(completionHandler: @escaping (Result<[LocalBroadcast]>) -> Void) {
        // see https://lokaleomroep.startpagina.nl/
        let broadcasts: [LocalBroadcast] = [
            LocalBroadcast(id: "rtvBaarn",
                           type: .local,
                           name: "RTV Baarn",
                           logoName: "rtvBaarn",
                           url: URL(string: "http://media.streamone.net/hlslive/account=BAYBN4ebT482/livestream=oZRNJcsRLQ4S/oZRNJcsRLQ4S.m3u8"),
                           imageURL: nil),
            LocalBroadcast(id: "6fm",
                           type: .local,
                           name: "6FM Huizen",
                           logoName: "6fm",
                           url: URL(string: "http://studiohilversum.6fm.nl:7007/hls/6fmtv.m3u8"),
                           imageURL: nil),
            LocalBroadcast(id: "slotstadZeist",
                           type: .local,
                           name: "Slotstad Zeist",
                           logoName: "slotStadZeist",
                           url: URL(string: "http://82.94.205.120:1935/slotstadrtv/slotstadrtv/playlist.m3u8"),
                           imageURL: nil)
        ]
        
        completionHandler(.success(broadcasts))
    }
}
