//
//  ContentView.swift
//  DBHelper
//
//  Created by naresh kukkala on 21/08/21.
//

import Foundation
import SQLite3

let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)

class DBHelper
{
    init()
    {
        db = openDatabase()
        createTable()
    }
    
    let dbPath: String = "myDb.sqlite"
    var db:OpaquePointer?
    
    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        print(fileURL)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    

    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS person(Id TEXT PRIMARY KEY, venue BLOB);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("person table created.")
            } else {
                print("person table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    func insert(id:String, venue: NSData)
    {
        let insertStatementString = "INSERT INTO person (Id, venue) VALUES (?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (id as NSString).utf8String, -1, nil)
            sqlite3_bind_blob(insertStatement, 2, venue.bytes, Int32(venue.length), SQLITE_TRANSIENT)
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func read() -> [VenueData] {
        let queryStatementString = "SELECT * FROM person;"
        var queryStatement: OpaquePointer? = nil
        var psns : [VenueData] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                guard let queryResultCol1 = sqlite3_column_text(queryStatement, 0) else {
                    print("Query result is nil.")
                    return psns
                }
                let name = String(cString: queryResultCol1) as NSString
                
                let len = sqlite3_column_bytes(queryStatement, 1)
                let point = sqlite3_column_blob(queryStatement, 1)
                if point != nil {
                    let dbData = NSData(bytes: point, length: Int(len))
                    
                    guard let finalArray =
                            try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(dbData as Data)
                    else {
                        return psns
                    }
                    print(finalArray)
                    if let data = (finalArray as AnyObject).data(using: String.Encoding.utf8.rawValue) {
                        do {
                            let decoder = JSONDecoder()
                            let jsonDictionary = try decoder.decode(Venues.self, from: data)
                            psns.append(VenueData(id: name as String, venue: jsonDictionary))
                        } catch {
                            // Handle error
                            print(error)
                        }
                    }
                }
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
    }
    
    func deleteByID(id:String) {
        let deleteStatementStirng = "DELETE FROM person WHERE Id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(deleteStatement, 1, id, -1,nil)
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
        print("delete")
    }
    
}
