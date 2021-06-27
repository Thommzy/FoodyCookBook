//
//  NSCache+Extension.swift
//  FoodyCookBook
//
//  Created by Tim on 27/06/2021.
//

import Foundation

extension NSCache {
  @objc class var sharedInstance: NSCache<NSString, AnyObject> {
      let cache = NSCache<NSString, AnyObject>()
      return cache
  }
}
