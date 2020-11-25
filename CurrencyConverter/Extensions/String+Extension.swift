//
//  String+Extension.swift
//  Marvel
//
//  Created by Ankush Singh on 23/11/20.
//

import Foundation
extension String {
  func stringByAppendingPathComponent(path: String) -> String {
    let nsSt = self as NSString
    return nsSt.appendingPathComponent(path)
  }
}
