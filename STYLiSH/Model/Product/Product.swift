//
//  Product.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/13.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import Foundation

struct PromotedProducts: Codable {

    let title: String

    let products: [Product]
}

struct Product: Codable {

    var id: Int

    var title: String

    var description: String

    var price: Int

    var texture: String

    var wash: String

    var place: String

    var note: String

    var story: String

    var colors: [Color]

    var sizes: [String]

    var variants: [Variant]

    var mainImage: String

    var images: [String]

    var size: String {

        return (sizes.first ?? "") + " - " + (sizes.last ?? "")
    }

    var stock: Int {

        return variants.reduce(0, { (previousData, upcomingData) -> Int in

            return previousData + upcomingData.stock
        })
    }

    enum CodingKeys: String, CodingKey {

        case id
        case title
        case description
        case price
        case texture
        case wash
        case place
        case note
        case story
        case colors
        case sizes
        case variants
        case mainImage = "main_image"
        case images
    }
}

struct Color: Codable {

    var name: String

    var code: String
}

struct Variant: Codable {

    var colorCode: String

    var size: String

    var stock: Int

    enum CodingKeys: String, CodingKey {

        case colorCode = "color_code"
        case size
        case stock
    }
}
