//  ModelAwareness.swift
//
//  Copyright (c) 2015 SobrKit (http://www.katun.ch)
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

import UIKit
import ObjectiveC

final class Lifted<T> {
    let value: T
    init(_ x: T) {
        value = x
    }
}

private func lift<T>(x: T) -> Lifted<T>  {
    return Lifted(x)
}

func setAssociatedObject<T>(object: AnyObject, value: T, associativeKey: UnsafePointer<Void>, policy: objc_AssociationPolicy) {
    if let v: AnyObject = value as? AnyObject {
        objc_setAssociatedObject(object, associativeKey, v,  policy)
    }
    else {
        objc_setAssociatedObject(object, associativeKey, lift(value),  policy)
    }
}

func associatedObject<T>(object: AnyObject, associativeKey: UnsafePointer<Void>) -> T? {
    if let v = objc_getAssociatedObject(object, associativeKey) as? T {
        return v
    }
    else if let v = objc_getAssociatedObject(object, associativeKey) as? Lifted<T> {
        return v.value
    }
    else {
        return nil
    }
}

public protocol ModelAwareControl {
    
    //MARK: - Properties
    var modelKeyPath: String? {get set}
    
    //MARK: - Methods
    func validate() -> Bool
    func prepare()
}


 extension UILabel: ModelAwareControl {
    
    private struct AssociatedKey {
        static var modelKeyPath = "modelKeyPath"
    }
    
    @IBInspectable public var modelKeyPath: String? {
        get {
            return associatedObject(self, &AssociatedKey.modelKeyPath)
        }
        set {
            if let value = newValue {
                setAssociatedObject(self, value, &AssociatedKey.modelKeyPath, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
            }
        }
    }
    
    public func prepare() {
        
    }
    
    public func validate() -> Bool {
        return true
    }
    
}

extension UITextView: ModelAwareControl {
    
    private struct AssociatedKey {
        static var modelKeyPath = "modelKeyPath"
        static var required = "required"
        static var errorBackgroundColor = "errorBackgroundColor"
        static var validBackgroundColor = "validBackgroundColor"
        static var normalBackgroundColor = "normalBackgroundColor"
    }
    
    @IBInspectable public var modelKeyPath: String? {
        get {
            return associatedObject(self, &AssociatedKey.modelKeyPath)
        }
        set {
            if let value = newValue {
                setAssociatedObject(self, value, &AssociatedKey.modelKeyPath, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
            }
        }
    }
    
    @IBInspectable var required: Bool {
        get {
            if let req: Bool = associatedObject(self, &AssociatedKey.required) {
                return req
            }
            else {
                return false
            }
        }
        set {
            setAssociatedObject(self, newValue, &AssociatedKey.required, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        }
    }
    
    @IBInspectable var errorBackgroundColor: UIColor? {
        get {
            if let color: UIColor = associatedObject(self, &AssociatedKey.errorBackgroundColor) {
                return color
            }
            else {
                return UIColor.redColor().colorWithAlphaComponent(0.5)
            }
        }
        set {
            if let value = newValue {
                setAssociatedObject(self, value, &AssociatedKey.errorBackgroundColor, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
            }
        }
    }
    @IBInspectable var validBackgroundColor: UIColor? {
        get {
            if let color: UIColor = associatedObject(self, &AssociatedKey.validBackgroundColor) {
                return color
            }
            else {
                return self.normalBackgroundColor
            }
        }
        set {
            if let value = newValue {
                setAssociatedObject(self, value, &AssociatedKey.validBackgroundColor, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
            }
        }
    }
    
    var normalBackgroundColor: UIColor? {
        get {
            return associatedObject(self, &AssociatedKey.normalBackgroundColor)
        }
        set {
            if let value = newValue {
                setAssociatedObject(self, value, &AssociatedKey.normalBackgroundColor, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
            }
        }
    }
    
    public func prepare() {
        self.normalBackgroundColor = self.backgroundColor
        self.validBackgroundColor = self.backgroundColor
    }
    
    public func validate() -> Bool {
        var valid = self.isValid()
        
        self.updateAppearance(valid)
        
        return valid
    }
    
    private func isValid() -> Bool {
        var valid = true
        
        if self.required {
            if let value = self.text {
                if !value.isEmpty {
                    valid = true
                }
                else{
                    valid = false
                }
            }
            else{
                valid = false
            }
        }
        else {
            valid = true
        }
        
        return valid
    }
    
    private func updateAppearance(valid: Bool) {
        if valid {
            if self.validBackgroundColor != nil {
                self.backgroundColor = self.validBackgroundColor
            }
        }
        else {
            if self.errorBackgroundColor != nil {
                self.backgroundColor = self.errorBackgroundColor
            }
        }
    }
}

extension UITextField: ModelAwareControl {
    
    private struct AssociatedKey {
        static var modelKeyPath = "modelKeyPath"
        static var required = "required"
        static var errorBackgroundColor = "errorBackgroundColor"
        static var validBackgroundColor = "validBackgroundColor"
        static var normalBackgroundColor = "normalBackgroundColor"
        static var validationPattern = "validationPattern"
    }
    
    @IBInspectable public var modelKeyPath: String? {
        get {
            return associatedObject(self, &AssociatedKey.modelKeyPath)
        }
        set {
            if let value = newValue {
                setAssociatedObject(self, value, &AssociatedKey.modelKeyPath, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
            }
        }
    }
    
    @IBInspectable var required: Bool {
        get {
            if let req: Bool = associatedObject(self, &AssociatedKey.required) {
                return req
            }
            else {
                return false
            }
        }
        set {
            setAssociatedObject(self, newValue, &AssociatedKey.required, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        }
    }
    
    @IBInspectable var errorBackgroundColor: UIColor? {
        get {
            if let color: UIColor = associatedObject(self, &AssociatedKey.errorBackgroundColor) {
                return color
            }
            else {
                return UIColor.redColor().colorWithAlphaComponent(0.5)
            }
        }
        set {
            if let value = newValue {
                setAssociatedObject(self, value, &AssociatedKey.errorBackgroundColor, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
            }
        }
    }
    @IBInspectable var validBackgroundColor: UIColor? {
        get {
            if let color: UIColor = associatedObject(self, &AssociatedKey.validBackgroundColor) {
                return color
            }
            else {
                return self.normalBackgroundColor
            }
        }
        set {
            if let value = newValue {
                setAssociatedObject(self, value, &AssociatedKey.validBackgroundColor, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
            }
        }
    }
    
    var normalBackgroundColor: UIColor? {
        get {
            return associatedObject(self, &AssociatedKey.normalBackgroundColor)
        }
        set {
            if let value = newValue {
                setAssociatedObject(self, value, &AssociatedKey.normalBackgroundColor, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
            }
        }
    }
    
    @IBInspectable var validationPattern: String? {
        get {
            return associatedObject(self, &AssociatedKey.validationPattern)
        }
        set {
            if let value = newValue {
                setAssociatedObject(self, value, &AssociatedKey.validationPattern, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
            }
        }
    }
    
    public func prepare() {
        self.normalBackgroundColor = self.backgroundColor
        self.validBackgroundColor = self.backgroundColor
    }
    
    public func validate() -> Bool {
        var valid = self.isValid()
        
        self.updateAppearance(valid)
        
        return valid
    }
    
    private func isValid() -> Bool {
        var valid = true
        
        if self.required {
            if let value = self.text {
                if !value.isEmpty {
                    valid = true
                }
                else{
                    valid = false
                }
            }
            else{
                valid = false
            }
        }
        else {
            valid = true
        }
        
        // at the moment we only check the pattern if it is valid up to this point
        // needs to be adjusted if we want to implement validation messages
        if valid && self.validationPattern != nil {
            if let value = self.text {
                if self.validationPattern!.lowercaseString == "email" {
                    valid = value.isValidEmail()
                }
                else {
                    valid = value.matchesRegex(validationPattern!)
                }
            }
        }
        
        return valid
    }
    
    private func updateAppearance(valid: Bool) {
        if valid {
            if self.validBackgroundColor != nil {
                self.backgroundColor = self.validBackgroundColor
            }
        }
        else {
            if self.errorBackgroundColor != nil {
                self.backgroundColor = self.errorBackgroundColor
            }
        }
    }
}

extension UISwitch: ModelAwareControl {
    
    private struct AssociatedKey {
        static var modelKeyPath = "modelKeyPath"
    }
    
    @IBInspectable public var modelKeyPath: String? {
        get {
            return associatedObject(self, &AssociatedKey.modelKeyPath)
        }
        set {
            if let value = newValue {
                setAssociatedObject(self, value, &AssociatedKey.modelKeyPath, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
            }
        }
    }
    
    public func prepare() {
        
    }
    
    public func validate() -> Bool {
        return true
    }
}

extension UISegmentedControl: ModelAwareControl {
    
    private struct AssociatedKey {
        static var modelKeyPath = "modelKeyPath"
        static var required = "required"
        static var errorTintColor = "errorTintColor"
        static var validTintColor = "validTintColor"
        static var normalTintColor = "normalTintColor"
    }
    
    @IBInspectable public var modelKeyPath: String? {
        get {
            return associatedObject(self, &AssociatedKey.modelKeyPath)
        }
        set {
            if let value = newValue {
                setAssociatedObject(self, value, &AssociatedKey.modelKeyPath, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
            }
        }
    }
    
    @IBInspectable var required: Bool {
        get {
            if let req: Bool = associatedObject(self, &AssociatedKey.required) {
                return req
            }
            else {
                return false
            }
        }
        set {
            setAssociatedObject(self, newValue, &AssociatedKey.required, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        }
    }
    
    @IBInspectable var errorTintColor: UIColor? {
        get {
            if let color: UIColor = associatedObject(self, &AssociatedKey.errorTintColor) {
                return color
            }
            else {
                return UIColor.redColor().colorWithAlphaComponent(0.5)
            }
        }
        set {
            if let value = newValue {
                setAssociatedObject(self, value, &AssociatedKey.errorTintColor, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
            }
        }
    }
    @IBInspectable var validTintColor: UIColor? {
        get {
            if let color: UIColor = associatedObject(self, &AssociatedKey.validTintColor) {
                return color
            }
            else {
                return self.normalTintColor
            }
        }
        set {
            if let value = newValue {
                setAssociatedObject(self, value, &AssociatedKey.validTintColor, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
            }
        }
    }
    
    var normalTintColor: UIColor? {
        get {
            return associatedObject(self, &AssociatedKey.normalTintColor)
        }
        set {
            if let value = newValue {
                setAssociatedObject(self, value, &AssociatedKey.normalTintColor, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
            }
        }
    }
    
    public func prepare() {
        self.normalTintColor = self.tintColor
        self.errorTintColor = UIColor.redColor().colorWithAlphaComponent(0.5)
        self.validTintColor = self.tintColor
    }
    
    public func validate() -> Bool {
        var valid = self.isValid()
        self.updateAppearance(valid)
        return valid
    }
    
    private func isValid() -> Bool {
        var valid = true
        
        if self.required {
            if self.selectedSegmentIndex == UISegmentedControlNoSegment {
                valid = false
            }
            else {
                valid = true
            }
        }
        
        return valid
    }
    
    private func updateAppearance(valid: Bool) {
        if valid {
            if validTintColor != nil {
                self.tintColor = self.validTintColor
            }
        }
        else {
            if errorTintColor != nil {
                self.tintColor = errorTintColor
            }
        }
    }
}

 extension UIViewController: UITextFieldDelegate, UITextViewDelegate {
    
    struct Static {
        static var onceToken : dispatch_once_t = 0
    }
    
    override public class func initialize() {
        dispatch_once(&Static.onceToken) {
            UIViewController.swizzle()
        }
    }
    
    class func swizzle() {
        println("[SobrKit] Swizzling UIViewController viewDidLoad & viewWillAppear methods...")
        UIViewController.swizzleMethodSelector("viewDidLoad", withSelector: "new_viewDidLoad", forClass: UIViewController.classForCoder())
        UIViewController.swizzleMethodSelector("viewWillAppear:", withSelector: "new_viewWillAppear:", forClass: UIViewController.classForCoder())
    }
    
    //MARK: - view lifecycle
    func new_viewDidLoad() {
        self.new_viewDidLoad()
        self.registerDelegates()
    }
    
    func new_viewWillAppear(animated: Bool) {
        self.new_viewWillAppear(animated)
        self.updateModelBindables()
    }
    
    //MARK: - Helpers
    private func registerDelegates() {
        var controls = self.modelAwareControlsInView(self.view)
        debugPrintln("[SobrKit] Found \(controls.count) model aware controls to register")
        for control in controls {
            if let keyPath = control.modelKeyPath {
                debugPrintln("[SobrKit] Bindable keyPath: \(keyPath)")
                
                control.prepare()
                
                if let modelAwareTextField = control as? UITextField {
                    modelAwareTextField.delegate = self
                    modelAwareTextField.addTarget(self, action: "valueChanged:", forControlEvents: .EditingChanged)
                }
                if let modelAwareTextView = control as? UITextView {
                    modelAwareTextView.delegate = self
                }
                else if let modelAwareSwitch = control as? UISwitch {
                    modelAwareSwitch.addTarget(self, action: "valueChanged:", forControlEvents: .ValueChanged)
                }
                else if let modelAwareSegmentedControl = control as? UISegmentedControl {
                    modelAwareSegmentedControl.addTarget(self, action: "valueChanged:", forControlEvents: .ValueChanged)
                }
            }
        }
    }
    
    public func updateModelBindables() {
        var controls = self.modelAwareControlsInView(self.view)
        debugPrintln("[SobrKit] Updating \(controls.count) model aware controls")
        for control in controls {
            if let keyPath = control.modelKeyPath {
                if let value: AnyObject = self.valueForKeyPath(keyPath) {
                    debugPrintln("Setting UI keyPath \(keyPath) to value: \(value)")
                    if let modelAwareTextField = control as? UITextField {
                        if let stringValue = value as? String {
                            modelAwareTextField.text = stringValue
                        }
                    }
                    if let modelAwareTextView = control as? UITextView {
                        if let stringValue = value as? String {
                            modelAwareTextView.text = stringValue
                        }
                    }
                    else if let modelAwareSwitch = control as? UISwitch {
                        if let boolValue = value as? Bool {
                            modelAwareSwitch.on = boolValue
                        }
                    }
                    else if let modelAwareSegmentedControl = control as? UISegmentedControl {
                        if let intValue = value as? Int {
                            modelAwareSegmentedControl.selectedSegmentIndex = intValue
                        }
                    }
                    else if let modelAwareLabel = control as? UILabel {
                        if let stringValue = value as? String {
                            modelAwareLabel.text = stringValue
                        }
                    }
                }
                
            }
        }
    }
    
    func modelAwareControlsInView(view: UIView) -> [ModelAwareControl] {
        var results = [ModelAwareControl]()
        for subview in view.subviews as! [UIView] {
            if let labelView = subview as? ModelAwareControl {
                results += [labelView]
            } else {
                results += self.modelAwareControlsInView(subview)
            }
        }
        return results
    }
    
    func validate() -> Bool {
        var valid = true
        
        var controls = self.modelAwareControlsInView(self.view)
        
        for control in controls {
            valid = valid && control.validate()
        }
        
        return valid
    }
    
    //MARK: UITextFieldDelegate
    public func textFieldDidEndEditing(textField: UITextField) {
        textField.validate()
    }
    
    //MARK: UITextViewDelegate
    public func textViewDidChange(textView: UITextView) {
        self.valueChanged(textView)
    }
    
    public func textViewDidEndEditing(textView: UITextView) {
        textView.validate()
    }
    
    //MARK: - value changed target
    func valueChanged(sender: AnyObject) {
        if let modelAwareControl = sender as? ModelAwareControl, let keyPath = modelAwareControl.modelKeyPath {
            
            var value: AnyObject?
            
            if let modelAwareTextField = modelAwareControl as? UITextField {
                value = modelAwareTextField.text
            }
            else if let modelAwareTextView = modelAwareControl as? UITextView {
                value = modelAwareTextView.text
            }
            else if let modelAwareSwitch = modelAwareControl as? UISwitch {
                value = modelAwareSwitch.on
            }
            else if let modelAwareSegmentedControl = modelAwareControl as? UISegmentedControl {
                value = modelAwareSegmentedControl.selectedSegmentIndex
            }
            else if let modelAwareLabel = modelAwareControl as? UILabel {
                value = modelAwareLabel.text
            }
            
            if(value != nil) {
                self.setValue(value, forKeyPath: keyPath)
                debugPrintln("[SobrKit] ModelAwareControl: Did set model keyPath: \(keyPath) to value \(value!)")
            }
        }
    }
}
