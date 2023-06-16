//
//  WLModelFile.swift
//  WisdomLeafApp
//
//  Created by Gopi on 15/06/23.
//

import Foundation

struct WLData: Codable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let url: String
    let downloadUrl: String
    var isSelected = false

    private enum CodingKeys: String, CodingKey {
        case id, author, width, height, url
        case downloadUrl = "download_url"
    }
}

typealias wlDataArray = [WLData]

