//
//  Extensions.swift
//  Memorize
//
//  Created by Andrew on 1/7/22.
//

import Foundation


extension Array {
    var only: Element? {
        return count == 1 ? first : nil
    }
}
