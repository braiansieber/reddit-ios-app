//
//  CoderExtension.swift
//  Reddit-App
//
//  Created by Marcelo Busico on 14/2/17.
//  Copyright © 2017 Busico. All rights reserved.
//

import Foundation

extension NSCoder {

  func decodeString(name: String) -> String {
    if let value = decodeObject(forKey: name) as? String {
      return value
    } else {
      return String()
    }
  }

  func decodeURL(name: String) -> URL? {
    if let value = decodeObject(forKey: name) as? String {
      return URL(string: value)
    } else {
      return nil
    }
  }
}
