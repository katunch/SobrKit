//  FoundationExtension.swift
//
//  Copyright (c) 2015 Software Brauerei AG (http://www.software-brauerei.ch)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation

//MARK: - String
public extension String {
    /// Convenience property to `count(self) as Int`.
    var length: Int {
        get {
            return count(self) as Int
        }
    }
    
    /**
    Searching for the string in your `Localizable.strings` in `NSBundle.mainBundle()` file and returns it's value.
    
    This method uses `NSLocalizedString`
    
    :returns: Returns a localized version of a string.
    */
    func localized() -> String {
        return NSLocalizedString(self, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "")
    }
    
    /**
    Searching for the string format in your `Localizable.strings` in `NSBundle.mainBundle()` file and returns it's value.
    
    :param: args A list of `arguments` to substitute into format.
    
    :returns: Returns a localized version of a string.
    */
    func localizedFormat(args: CVarArgType) -> String {
        return NSString(format: self.localized(), args) as String
    }
    
    /**
    Returns a Boolean value indicating whether the string is a valid email address.
    
    :returns: Returns `true` if the string is a valid email address otherwise it returns `false`.
    */
    func isValidEmail() -> Bool {
        return self.matchesRegex("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}")
    }
    
    /**
    Returns a Boolean value indicating whether the string matches the given regex pattern.
    
    :param: regex A Regex pattern
    
    :returns: Returns `true` if the string matches the regex. Otherwise `false`.
    */
    func matchesRegex(regex: String) -> Bool {
        var test = NSPredicate(format:"SELF MATCHES %@", regex)
        let result = test.evaluateWithObject(self)
        return result
    }
    
    /**
    Returns a new String without whitespaces.
    
    :returns: String without whitespaces.
    */
    func condenseWhitespace() -> String {
        let components = self.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        return "".join(components)
    }
    
    /**
    Returns a Boolean value indicating whether the string is equal to "true".
    
    :returns: Returns `true` if the String is equal to "true". Otherwise `false`.
    */
    func toBool() -> Bool {
        return self == "true"
    }

    /**
    The floating-point value of the string as a double
    
    This property doesn’t include any whitespace at the beginning of the string. This property is `HUGE_VAL` or `–HUGE_VAL` on overflow, `0.0` on underflow. This property is `0.0` if the string doesn’t begin with a valid text representation of a floating-point number.
    
    This property uses formatting information stored in the non-localized value; use an `NSScanner` object for localized scanning of numeric values from a string.
    
    :returns: Double value
    */
    func toDouble() -> Double {
        return (self as NSString).doubleValue
    }
}

//MARK: - Double
public extension Double {
    /**
    Returns an `String` object from a `Double` with the given format.
    
    :Examples:
    `e.g. ".2" for two decimal characters`.
    
    `e.g. ".0" for no decimal characters`.
    
    :Implementation:
    `NSString(format: "%\(format)f", self) as String`
    
    :param: format The String format for Double representation 
    
    :returns: The formatted String
    */
    func stringWithFormat(format: String) -> String {
        return NSString(format: "%\(format)f", self) as String
    }
}

//MARK: - NSObject
public extension NSObject {
    
    /**
    Swizzles instance methods of a class.
    
    :param: origSelector The method which will be replaced.
    :param: withSelector The method which will be inserted.
    :param: forClass     The class which method will be swizzled.
    
    :returns: Returns `true` if the the method swizzle was successfull. Otherwise `false`.
    */
    class func swizzleMethodSelector(origSelector: String!, withSelector: String!, forClass:AnyClass!) -> Bool {
        
        var originalMethod: Method?
        var swizzledMethod: Method?
        
        originalMethod = class_getInstanceMethod(forClass, Selector(origSelector))
        swizzledMethod = class_getInstanceMethod(forClass, Selector(withSelector))
        
        if (originalMethod != nil && swizzledMethod != nil) {
            method_exchangeImplementations(originalMethod!, swizzledMethod!)
            return true
        }
        return false
    }
    
    /**
    Swizzles class methods of a class.
    
    :param: origSelector The method which will be replaced.
    :param: withSelector The method which will be inserted.
    :param: forClass     The class which method will be swizzled.
    
    :returns: Returns `true` if the the method swizzle was successfull. Otherwise `false`.
    */
    class func swizzleStaticMethodSelector(origSelector: String!, withSelector: String!, forClass:AnyClass!) -> Bool {
        
        var originalMethod: Method?
        var swizzledMethod: Method?
        
        originalMethod = class_getClassMethod(forClass, Selector(origSelector))
        swizzledMethod = class_getClassMethod(forClass, Selector(withSelector))
        
        if (originalMethod != nil && swizzledMethod != nil) {
            method_exchangeImplementations(originalMethod!, swizzledMethod!)
            return true
        }
        return false
    }
}

//MARK: - NSURL
public extension NSURL {
    /**
    Returns a `[String: String]` Array of all query parameters.
    
    :returns: `[String: String]` Array of all query parameters.
    */
    func queryParameters() -> [String: String] {
        var returnData: [String: String] = [String: String]()
        
        if let query = self.query {
            let keyValuePairs = split(query) { $0 == "&" }
            
            for keyValuePair in keyValuePairs {
                let splits = split(keyValuePair) {$0 == "="}
                let key = splits[0] as String
                let value = splits[1] as String
                returnData[key] = value
            }
        }
        
        return returnData
    }
}

//MARK: - NSDate
extension NSDate {
    func isGreaterThanDate(dateToCompare : NSDate) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    
    func isLessThanDate(dateToCompare : NSDate) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    
    func isEqualToDate(dateToCompare : NSDate) -> Bool {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedSame {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }
    
    
    
    func addDays(daysToAdd : Int) -> NSDate {
        var secondsInDays : NSTimeInterval = Double(daysToAdd) * 60 * 60 * 24
        var dateWithDaysAdded : NSDate = self.dateByAddingTimeInterval(secondsInDays)
        
        //Return Result
        return dateWithDaysAdded
    }
    
    
    func addHours(hoursToAdd : Int) -> NSDate {
        var secondsInHours : NSTimeInterval = Double(hoursToAdd) * 60 * 60
        var dateWithHoursAdded : NSDate = self.dateByAddingTimeInterval(secondsInHours)
        
        //Return Result
        return dateWithHoursAdded
    }
}
