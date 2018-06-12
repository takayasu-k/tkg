//
//  PrefData.swift
//  TKG
//
//  Created by taka on 2018/05/09.
//  Copyright © 2018年 tkg. All rights reserved.
//

import Foundation


// 店舗のある都道府県と店舗数の一覧を受け取るための構造体
struct PrefData: Codable {
  // idに関しては不要なのでサーバー側で消去した後にこちらも削除
  var id: Int?
  var prefID: Int
  var prefName: String
  var shopCount: Int
  
  private enum CodingKeys: String, CodingKey {
    case id = "id"
    case prefID = "pref_id"
    case prefName = "pref_name"
    case shopCount = "shop_count"
  }
}


// 店舗の一覧を受け取るための構造体
struct ShopData: Codable {
  var shopID: Int
  var shopName: String
  var shopAddress: String
  var shopTel: String?
  var shopImage: ShopImage
  
  struct ShopImage: Codable {
    var url: String?
    var thumb: [String:String?]
  }
  
  
//  var shops: [ShopData] = [ShopData]()
  
//  init(from decoder: Decoder) throws {
//    // デコードのためのコンテナを取得
//    let container = try decoder.container(keyedBy: CodingKeys.self)
//    // コンテナ内のキーを取得。
//    let keys = container.allKeys
//    // キーを使用して検索結果を一件ずつ取り出す
//    for key in keys {
//      // 検索結果１件に対するデコード処理
//      let shop = try container.decode(ShopData.self, forKey: key)
//      // デコード処理できたら検索結果の一覧に追加
//      shops.append(shop)
//    }
//  }
//   エンコード処理
//  func encode(to encoder: Encoder) throws {
//    // レスポンスを解析するだけなので実装不要
//  }
  
//  struct ShopImage: Codable {
//    var url: String?
//
//    struct Thumb: Codable {
//      var url: String?
//    }
//    var thumb: Thumb
//
//    init(from decoder: Decoder) throws {
//      let container = try decoder.container(keyedBy: CodingKeys.self)
//      // コンテナ内のキーを取得。
//      let keys = container.allKeys
//      // キーを使用して検索結果を一件ずつ取り出す
//      for key in keys {
//        // 検索結果１件に対するデコード処理
//        let shopImage = try container.decode(ShopImage.self, forKey: key)
//      }
//    }
    // エンコード処理
//    func encode(to encoder: Encoder) throws {
//      // レスポンスを解析するだけなので実装不要
//    }
//
//    private enum CodingKeys: String, CodingKey {
//      case url = "url"
//      case thmub = "thumb"
//    }
//  }

  private enum CodingKeys: String, CodingKey {
    case shopID = "id"
    case shopName = "name"
    case shopAddress = "address"
    case shopTel = "tel"
    case shopImage = "prof_picture"
  }
}

// 店舗の詳細情報を受け取るための構造体
struct ShopDetail: Codable {
  var operatingHours: Int
  var holiday: String
  var payment: Int
  
  private enum CodingKeys: String, CodingKey {
    case operatingHours = "operating_hours"
    case holiday = "holiday"
    case payment = "payment"
  }
}
