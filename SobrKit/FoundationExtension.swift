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
    var length: Int {
        get {
            return count(self) as Int
        }
    }
    
    func localized() -> String {
        return NSLocalizedString(self, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "")
    }
    
    func localizedFormat(args: CVarArgType) -> String {
        return NSString(format: self.localized(), args) as String
    }
    
    func isValidEmail() -> Bool {
        return self.matchesRegex("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}")
    }
    
    func matchesRegex(regex: String) -> Bool {
        var test = NSPredicate(format:"SELF MATCHES %@", regex)
        let result = test.evaluateWithObject(self)
        return result
    }
    
    func condenseWhitespace() -> String {
        let components = self.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        return "".join(components)
    }
    
    func toBool() -> Bool {
        return self == "true"
    }

    func toDouble() -> Double {
        return (self as NSString).doubleValue
    }
}

//MARK: - Double
public extension Double {
    func stringWithFormat(format: String) -> String {
        return NSString(format: "%\(format)f", self) as String
    }
}

//MARK: - NSObject
public extension NSObject {
    
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
    func queryParameters() -> [String: String] {
        
        let query = self.query!
        let keyValuePairs = split(query) { $0 == "&" }
        
        var returnData: [String: String] = [String: String]()
        
        for keyValuePair in keyValuePairs {
            let splits = split(keyValuePair) {$0 == "="}
            let key = splits[0] as String
            let value = splits[1] as String
            returnData[key] = value
        }
        
        return returnData
    }
}
