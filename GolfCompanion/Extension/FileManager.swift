//
//  FileManager.swift
//  GolfCompanion
//
//  Created by Marriott, Rafe (NA) on 03/12/2025.
//

import Foundation

extension FileManager {
    private func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func saveBag(to filePath: String, object: Bag) {
        //encode to JSON
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(object) {
            if let json = String(data: encoded, encoding: .utf8) {
                //get path to file to save to in user document directory
                let url = getDocumentDirectory().appendingPathComponent(filePath)
                //write json to file
                do {
                    try json.write(to: url, atomically: true, encoding: .utf8)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func loadBag(from filePath: String) -> Bag? {
        //get path to file
        let url = getDocumentDirectory().appendingPathComponent(filePath)
        //read from file
        if let data = try? Data(contentsOf: url) {
            //decode from JSON into Bag
            let decoder = JSONDecoder()
            if let bag = try? decoder.decode(Bag.self, from: data) {
                return bag
            } else {
                print("Failed to decode from JSON")
                return nil
            }
        } else {
            print("Couldn't read from file at given path")
            return nil
        }
    }
}
