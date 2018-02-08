//
//  Channel.swift
//  NPO
//
//  Created by Jeroen Wesbeek on 27/10/2017.
//  Copyright © 2017 Jeroen Wesbeek. All rights reserved.
//

import Foundation

// Some unknown (incorrect?) channel names the API returns:
// - POMS_S_KRO_098910 -> Spoorloos
// - KN_1684845 -> Mijn Maria
// - OPVO -> The Passion
// - POMS_S_MAX_374456 -> Zwarte Zwanen
// - POW_03344601 -> Vier seizoenen aan de Amstel
// - VPWON_1246643 -> Ondersteboven Nederland in de jaren 60
// - POMS_S_NCRV_059866 -> Schepper & Co
// - RAD5 -> De dienst van Freek

public enum Channel: String, Codable {
    case unkown
    case npo1 = "NED1"
    case npo2 = "NED2"
    case npo3 = "NED3"
    case zappelin = "ZAPP"
    case zappelinExtra = "ZAPPE"
    case cultura = "CULT"
    case omroepGelderland = "GELD"
    case rtvDrenthe = "TVDR"
    case omroepBrabant = "BRAB"
}

extension Channel {
    public var name: String? {
        switch self {
        case .unkown:
            return nil
        case .npo1:
            return "NPO 1"
        case .npo2:
            return "NPO 2"
        case .npo3:
            return "NPO 3"
        case .zappelin:
            return "Zappelin"
        case .zappelinExtra:
            return "Zappelin Xtra"
        case .cultura:
            return "Cultura"
        case .omroepGelderland:
            return "Omroep Gelderland"
        case .rtvDrenthe:
            return "RTV Drenthe"
        case .omroepBrabant:
            return "Omroep Brabant"
        }
    }
    
    public var logo: UXImage? {
        switch self {
        case .unkown:
            return nil
        case .npo1:
            return UXImage(withName: "npo1")
        case .npo2:
            return UXImage(withName: "npo2")
        case .npo3:
            return UXImage(withName: "npo3")
        case .zappelin:
            return UXImage(withName: "zappelin24")
        case .zappelinExtra:
            return UXImage(withName: "zappxtra")
        case .cultura:
            return UXImage(withName: "cultura24")
        case .omroepGelderland:
            return UXImage(withName: "omroepGelderland")
        case .rtvDrenthe:
            return UXImage(withName: "rtvDrenthe")
        case .omroepBrabant:
            return UXImage(withName: "omroepBrabant")
        }
    }
}
