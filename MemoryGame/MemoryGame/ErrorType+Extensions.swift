//
//  ErrorType+Extensions.swift
//  MemoryGame
//
//  Created by Kuliza-282 on 11/05/17.
//  Copyright © 2017 Kuliza-282. All rights reserved.
//

import Foundation

protocol LocalizedError {
    var localizedDescription: String { get }
}
extension NSError: LocalizedError { }


//MG: one of the two cases above will always be satisfied... this is just here to apease the compiler :(
// a side effect of Apple making NSError conform to ErrorType - without a protocol such as LocalizedError
// we are unable to make the compiler tell them apart (hence why the 'as' cast below just works)

extension Error {
    func displayString() -> String {
        if let error = self as? LocalizedError {
            return error.localizedDescription
        } else if let error = self as? CustomStringConvertible {
            return error.description
        }
        
        return (self as NSError).description
    }
}
