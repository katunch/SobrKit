//  AlamofireExtension.swift
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
import Alamofire

/**
*  Defines an object which can be instantiated from a serialized object.
*/
public protocol ResponseObjectSerializable: class {
    /**
    Init method which has to be implemented by the object to map the representation to the object.
    
    :param: response       `NSHTTPURLResponse`
    :param: representation Representation of the parsed response body (By Alamofire).
    
    :returns: Instance of the object.
    */
    init(response: NSHTTPURLResponse, representation: AnyObject)
}


/**
*  Defines an object which can be instantiated from a serialized collection.
*/
public protocol ResponseCollectionSerializable: class {
    /**
    Init method which has to be implemented by the object to map a collection of representations to the object.
    
    :param: response       `NSHTTPURLResponse`
    :param: representation Representation of the parsed response body (By Alamofire).
    
    :returns: Array of instances of the object.
    */
    static func collection(#response: NSHTTPURLResponse, representation: AnyObject) -> [Self]
}

/**
*  Defines some convenience response parsing methods for Alamofire.
*/
extension Alamofire.Request {
    
    /**
    JSON response to Object
    
    :param: completionHandler The completion handler
    
    :returns: Returns an Alamofire response.
    */
    public func responseObject<T: ResponseObjectSerializable>(completionHandler: (NSURLRequest, NSHTTPURLResponse?, T?, NSError?) -> Void) -> Self {
        let serializer: Serializer = { (request, response, data) in
            let JSONSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let (JSON: AnyObject?, serializationError) = JSONSerializer(request, response, data)
            if response != nil && JSON != nil {
                return (T(response: response!, representation: JSON!), nil)
            }
            else {
                return (nil, serializationError)
            }
        }
        
        return response(serializer: serializer, completionHandler: { (request, response, object, error) in
          completionHandler(request, response, object as? T, error)
        })
    }
    
    /**
    JSON response to an Array of objects.
    
    :param: completionHandler The completion handler.
    
    :returns: Returns an Alamofire response.
    */
    public func responseCollection<T: ResponseCollectionSerializable>(completionHandler: (NSURLRequest, NSHTTPURLResponse?, [T], NSError?) -> Void) -> Self {
        let serializer: Serializer = { (request, response, data) in
            let JSONSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let (JSON: AnyObject?, serializationError) = JSONSerializer(request, response, data)
            if response != nil && JSON != nil {
                return (T.collection(response: response!, representation: JSON!), nil)
            }
            else {
                return ([], serializationError)
            }
        }
        
        return response(serializer: serializer, completionHandler: { (request, response, object, error) in
            completionHandler(request, response, object as! [T], error)
        })
    }
}

