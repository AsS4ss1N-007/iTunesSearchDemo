//
//  SongDetails.swift
//  iTunesSearchDemo
//
//  Created by Sachin's Macbook Pro on 06/04/21.
//

import UIKit
import Foundation

struct SongInfo: Codable {
    let resultCount: Int?
    let results: [Result]?
}

struct Result: Codable {
    let trackName: String?
    let artistName: String?
}
