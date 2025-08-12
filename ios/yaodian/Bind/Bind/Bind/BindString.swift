//
//  KeString.swift
//  ChainKit
//
//  Created by wangteng on 2022/8/22.
//

import UIKit

extension String: Bindble { }

public extension Bind where T == String {
    
    var url: URL? {
        URL(string: self.base)
    }
    
    /// Check if string is a valid URL
    var isValidUrl: Bool {
        guard let url = URL(string: self.base) else { return false }
        return (url.scheme == "http" || url.scheme == "https")
    }

    /// UIImage(named: self.base)
    var image: UIImage? {
        UIImage(named: self.base)
    }

    /// String decoded from base64 (if applicable).
    var base64Decoded: String? {
        guard let decodedData = Data(base64Encoded: self.base) else { return nil }
        return String(data: decodedData, encoding: .utf8)
    }

    /// String encoded in base64 (if applicable).
    var base64Encoded: String? {
        let plainData = self.base.data(using: .utf8)
        return plainData?.base64EncodedString()
    }
    
    /// Check if string is a valid https URL.
    var isValidHttpsUrl: Bool {
        guard let url = URL(string: self.base) else { return false }
        return url.scheme == "https"
    }
    
    /// Check if string is a valid http URL.
    var isValidHttpUrl: Bool {
        guard let url = URL(string: self.base) else { return false }
        return url.scheme == "http"
    }
    
    var bool: Bool? {
        let selfLowercased = self.trimmed.lowercased()
        if selfLowercased == "true" || selfLowercased == "1" {
            return true
        } else if selfLowercased == "false" || selfLowercased == "0" {
            return false
        }
        return nil
    }
    
    var screenBounds: CGRect {
        UIScreen.main.bounds
    }
    
    /// Check if string contains one or more letters.
    var hasLetters: Bool {
        return self.base.rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
    }
    
    /// Check if string contains one or more numbers.
    var hasNumbers: Bool {
        return self.base.rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
    }
    
    /// Check if string is valid email format.
    var isEmail: Bool {
        return self.regular(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
    }
    
    ///  Verify if string matches the regex pattern.
    ///
    /// - Parameter pattern: Pattern to verify.
    /// - Returns: true if string matches the pattern.
    func regular(pattern: String) -> Bool {
        return self.base.range(of: pattern,
                     options: String.CompareOptions.regularExpression,
                     range: nil, locale: nil) != nil
    }
    
    /// Check if string contains one or more emojis.
    ///
    ///        "Hello 😀".bind.containEmoji -> true
    ///
    var containEmoji: Bool {
        for scalar in self.base.unicodeScalars {
            switch scalar.value {
            case 0x3030, 0x00AE, 0x00A9, // Special Characters
            0x1D000...0x1F77F, // Emoticons
            0x2100...0x27BF, // Misc symbols and Dingbats
            0xFE00...0xFE0F, // Variation Selectors
            0x1F900...0x1F9FF: // Supplemental Symbols and Pictographs
                return true
            default:
                continue
            }
        }
        return false
    }
    
    /// String with no spaces or new lines in beginning and end.
    var trimmed: String {
        return self.base.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Readable string from a URL string.
    var urlDecoded: String {
        return self.base.removingPercentEncoding ?? self.base
    }
    
    ///  Escape string.
    var urlEncode: String? {
        return self.base.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
    /// The floating-point value of the string as a float.
    var integerValue: Int {
        return (base as NSString).integerValue
    }
    
    var floatValue: Float {
        return (base as NSString).floatValue
    }
    
    /// The floating-point value of the string as a double.
    var doubleValue: Double {
        return (base as NSString).doubleValue
    }
    
    /// The Boolean value of the string.
    var boolValue: Bool {
        return (base as NSString).boolValue
    }
 
    /// Calculates and returns the bounding rect for the receiver drawn
    /// using the given options and display characteristics,
    ///  within the specified rectangle in the current graphics context.
    func boundingRect(_ rect: BoundingRect) -> CGFloat {
        switch rect {
        case let .attributesWidth(height, attributes):
            return NSString(string: self.base).boundingRect(with: .init(width: CGFloat.greatestFiniteMagnitude,
                                                                         height: CGFloat(height)),
                                                            options: .usesLineFragmentOrigin,
                                                            attributes: attributes,
                                                            context: nil).width
        case let .fontWidth(height, font):
            return NSString(string: self.base).boundingRect(with: .init(width: CGFloat.greatestFiniteMagnitude,
                                                                        height: CGFloat(height)),
                                                            options: .usesLineFragmentOrigin,
                                                            attributes: [.font: font],
                                                            context: nil).width
        
        case let .attributesHeight(width, attributes):
            return NSString(string: self.base).boundingRect(with: .init(width: width,
                                                                        height: CGFloat.greatestFiniteMagnitude),
                                                            options: .usesLineFragmentOrigin,
                                                            attributes: attributes,
                                                            context: nil).height
            
        case let .fontHeight(width, font):
            return NSString(string: self.base).boundingRect(with: .init(width: width,
                                                                        height: CGFloat.greatestFiniteMagnitude),
                                                            options: .usesLineFragmentOrigin,
                                                            attributes: [.font: font],
                                                            context: nil).height
        default:
            return .zero
        }
    }
    
    /// Calculates and returns the bounding rect for the receiver drawn
    /// using the given options and display characteristics,
    ///  within the specified rectangle in the current graphics context.
    func boundingSize(_ rect: BoundingRect) -> CGSize {
        switch rect {
        case let .attributesWidth(height, attributes):
            return NSString(string: self.base).boundingRect(with: .init(width: CGFloat.greatestFiniteMagnitude,
                                                                         height: CGFloat(height)),
                                                            options: .usesLineFragmentOrigin,
                                                            attributes: attributes,
                                                            context: nil).size
        case let .fontWidth(height, font):
            return NSString(string: self.base).boundingRect(with: .init(width: CGFloat.greatestFiniteMagnitude,
                                                                        height: CGFloat(height)),
                                                            options: .usesLineFragmentOrigin,
                                                            attributes: [.font: font],
                                                            context: nil).size
        
        case let .attributesHeight(width, attributes):
            return NSString(string: self.base).boundingRect(with: .init(width: width,
                                                                        height: CGFloat.greatestFiniteMagnitude),
                                                            options: .usesLineFragmentOrigin,
                                                            attributes: attributes,
                                                            context: nil).size
            
        case let .fontHeight(width, font):
            return NSString(string: self.base).boundingRect(with: .init(width: width,
                                                                        height: CGFloat.greatestFiniteMagnitude),
                                                            options: .usesLineFragmentOrigin,
                                                            attributes: [.font: font],
                                                            context: nil).size
        case let .size(maxWidth, font):
            return NSString(string: self.base).boundingRect(with: .init(width: maxWidth,
                                                                        height: CGFloat.greatestFiniteMagnitude),
                                                            options: .usesLineFragmentOrigin,
                                                            attributes: [.font: font],
                                                            context: nil).size
        }
    }
    
    enum BoundingRect {
        case attributesWidth(height: CGFloat, attributes: [NSAttributedString.Key: Any])
        case fontWidth(height: CGFloat, font: UIFont)
        case attributesHeight(width: CGFloat, attributes: [NSAttributedString.Key: Any])
        case fontHeight(width: CGFloat, font: UIFont)
        case size(maxWidth: CGFloat, font: UIFont)
    }
    
    func format(_ formatter: Formatter) -> String {
        
        switch formatter {
        case .number(let numberFormatter):
            return numberFormatter.string(for: self.base) ?? ""
        case .date(let dateFormatType):
            let date = Date(timeIntervalSince1970: TimeInterval(self.base.bind.doubleValue))
            let formatter = DateFormatterManager.shared.dateFormatter
            formatter.locale = Locale(identifier: "en_US_POSIX")
            switch dateFormatType {
            case .date:
                formatter.dateFormat = "yyyy-MM-dd"
            case .dateAndTime:
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            case let .custom(dateFormat):
                formatter.dateFormat = dateFormat
            }
            return formatter.string(from: date)
        }
    }
    
    enum Formatter {
        case number(NumberFormatter)
        case date(DateFormatType)
    }
    
    enum DateFormatType {
        case date
        case dateAndTime
        case custom(String)
    }
    
    var numberFormat: String {
        guard let intValue = Int(self.base) else {
            return self.base
        }
        switch intValue {
        case ...0:
            return "0"
        case 1...9999:
            return self.base
        case 10000...:
            switch intValue%10000 {
            case 0:
                return "\(intValue/10000)万"
            default:
                let formatValue = Double(intValue)/10000.0
                let formatString = String(format: "%.1f", formatValue)
                
                let components = formatString.components(separatedBy: ".")
                if components.count >= 2 {
                    if let last = components.last?.bind.doubleValue, last > 0 {
                        return formatString+"万"
                    } else {
                        return "\(components.first!)"+"万"
                    }
                } else {
                    return formatString+"万"
                }
            }
        default:
            return self.base
        }
    }
    
    func numberFormat(placeholder: String = "") -> String {
        guard let intValue = Int(self.base) else {
            return self.base
        }
        if intValue <= 0 {
            return placeholder
        }
        return self.numberFormat
    }
}

class DateFormatterManager {
    
    static let shared = DateFormatterManager()
    
    let dateFormatter = DateFormatter()
}

public extension NumberFormatter {
    
    static var decimal: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        formatter.minimumIntegerDigits = 1
        return formatter
    }
}
