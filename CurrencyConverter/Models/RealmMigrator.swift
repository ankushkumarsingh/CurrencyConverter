//
//  RealmMigrator.swift
//  CurrencyConverter
//
//  Created by Ankush Singh on 24/11/20.
//

import Foundation
import RealmSwift

enum RealmMigrator {
  static private func migrationBlock(
    migration: Migration,
    oldSchemaVersion: UInt64
  ) {
    if oldSchemaVersion < 1 {
      migration.enumerateObjects(ofType: CurrencyLayerDB.className()) { _, newObject in
        newObject?["source"] = "USD"
      }
    }
  }

  static func setDefaultConfiguration() {
    let config = Realm.Configuration(
      schemaVersion: 1,
      migrationBlock: migrationBlock)
    Realm.Configuration.defaultConfiguration = config
  }
}
