//
//  DownloadQueueProtocol.swift
//  CurrencyConverter
//
//  Created by Ankush Singh on 24/11/20.
//

import Foundation
public protocol DownloadQueueProtocol {
  func enqueueDownload(_ operation: Operation)
  func isOperationInProgress(forNames names: [String]) -> Bool
}
