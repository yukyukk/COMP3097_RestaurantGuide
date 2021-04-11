//
//  DBHelper.swift
//  Restaurant_Guide
//
//  Created by Jes Muli on 2021-03-13.
//

import Foundation
import SQLite3

class DBHelper {
    var db: OpaquePointer?
    var path : String = "restoDB.sqlite"
    
    init() {
        self.db = createDB()
        self.createTable()
    }
    
    //
    func createDB() -> OpaquePointer? {
        let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathExtension(path)
        
        var db : OpaquePointer? = nil
        
        // if successful
        if sqlite3_open(filePath.path, &db) != SQLITE_OK {
            print("There is an error in created DB")
            return nil
        } else {
            print("Database has been created with path \(path)")
            return db
        }
    }
    
    func createTable() {
        let query = "CREATE TABLE IF NOT EXISTS restaurant(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, street TEXT, city TEXT, country TEXT, postal_code TEXT, phone TEXT, tag TEXT, rating TEXT, description TEXT);"
        
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Database Tables have been created successfully")
            } else {
                print("Table creation fail")
            }
        } else {
            print("Preparation failed")
        }
    }
}
