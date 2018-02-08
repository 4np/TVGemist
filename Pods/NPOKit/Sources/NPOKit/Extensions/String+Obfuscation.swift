//
//  String+Obfuscation.swift
//  NPO
//
//  Created by Jeroen Wesbeek on 01/02/2018.
//  Copyright © 2018 Jeroen Wesbeek. All rights reserved.
//

import Foundation

extension String {
    /// Just come random key for XOR-ing so we don't have people Googling their
    /// way here when searching for specific strings...
    private static let xorKey = [UInt8]("5thjdfgd8fhfsd83hjeafsjds84hjs8w".utf8)
    
    /// Obfuscate a String (String > XOR > Hex)
    var obfuscated: String {
        let text = [UInt8](self.utf8)
        let encrypted = text.enumerated().map({ $0.element ^ String.xorKey[$0.offset] })
        return encrypted.map { String(format: "%02x", $0) }.joined()
    }
    
    /// Deobfuscate a String (Hex > XOR > String)
    var deobfuscated: String? {
        var data = Data(capacity: self.count / 2)
        
        guard let regex = try? NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive) else { return nil }
        
        regex.enumerateMatches(in: self, options: .anchored, range: NSRange(location: 0, length: utf16.count)) { (result, _, _) in
            guard let match = result?.range, let range = Range(match, in: self), let number = UInt8(self[range], radix: 16) else { return }
            var mutableNumber = number
            data.append(&mutableNumber, count: 1)
        }
        
        let decrypted = data.enumerated().map({ $0.element ^ String.xorKey[$0.offset] })
        return String(bytes: decrypted, encoding: .utf8)
    }
}
