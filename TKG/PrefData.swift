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
  var operatingHours: String?
  var holiday: String?
  var payment: String?
  
  private enum CodingKeys: String, CodingKey {
    case operatingHours = "operating_hours"
    case holiday = "holiday"
    case payment = "payment"
  }
}

// 店舗のメニューデータを受け取るための構造体
struct MenuData: Codable {
  var menuID: Int
  var menuName: String
  var menuPrice: Int
  var menuImage: MenuImage
  
  struct MenuImage: Codable {
    var url: String?
    var thumb: [String:String?]
  }
  
  private enum CodingKeys: String, CodingKey {
    case menuID = "id"
    case menuName = "name"
    case menuPrice = "price"
    case menuImage = "prof_picture"
  }
}
