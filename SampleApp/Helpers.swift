//
//  Helpers.swift
//  SampleApp
//
//  Created by Harvey Mackie on 17/01/2024.
//

import Foundation
import SwiftUI

func parseDate(from dateString: String) -> String? {
    let dateFormatter = ISO8601DateFormatter()
    dateFormatter.formatOptions = [.withFullDate]
    if let date = dateFormatter.date(from: dateString) {
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd MMM yyyy"
        return outputFormatter.string(from: date)
    } else {
        return nil
    }
}
