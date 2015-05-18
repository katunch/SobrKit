//  ModelAwareness.swift
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

/**
*  Defines a control which is aware of an associated modelKeyPath.
*/
public protocol ModelAwareControl {
    
    //MARK: - Properties
    /// The keyPath which the control is aware of.
    var modelKeyPath: String? {get set}
    
    /// Tells the control if it should observe the `modelKeyPath` in realtime and apply changes.
    var realtime: Bool {get set}
    
    //MARK: - Methods
    /**
    Check if the current input is valid.
    
    :returns: Returns `true` if the contents are valid. Otherwise `false`.
    */
    func validate() -> Bool
    
    /**
    This function is used by the controls to do some init stuff after it is recognized as a ModelAwareControl.
    */
    func prepare()
}

extension UILabel: ModelAwareControl {
    
    private struct AssociatedKey {
        static var modelKeyPath = "modelKeyPath"
        static var realtime = "realtime"
    }
    
    /// See ModelAwareControl protocol
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
    
    /// See ModelAwareControl protocol
    @IBInspectable public var realtime: Bool {
        get {
            if let rt: Bool = associatedObject(self, &AssociatedKey.realtime) {
                return rt
            }
            else{
                return false
            }
        }
        set {
            setAssociatedObject(self, newValue, &AssociatedKey.realtime, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        }
    }
    
    /// See ModelAwareControl protocol
    public func prepare() {
        
    }
    
    /// See ModelAwareControl protocol
    public func validate() -> Bool {
        return true
    }
    
}

extension UITextView: ModelAwareControl {
    
    private struct AssociatedKey {
        static var modelKeyPath = "modelKeyPath"
        static var realtime = "realtime"
        static var required = "required"
        static var errorBackgroundColor = "errorBackgroundColor"
        static var validBackgroundColor = "validBackgroundColor"
        static var normalBackgroundColor = "normalBackgroundColor"
    }
    
    /// See ModelAwareControl protocol
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
    
    /// See ModelAwareControl protocol
    @IBInspectable public var realtime: Bool {
        get {
            if let rt: Bool = associatedObject(self, &AssociatedKey.realtime) {
                return rt
            }
            else{
                return false
            }
        }
        set {
            setAssociatedObject(self, newValue, &AssociatedKey.realtime, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
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
    
    /// See ModelAwareControl protocol
    public func prepare() {
        self.normalBackgroundColor = self.backgroundColor
        self.validBackgroundColor = self.backgroundColor
    }
    
    /// See ModelAwareControl protocol
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
        static var realtime = "realtime"
        static var required = "required"
        static var errorBackgroundColor = "errorBackgroundColor"
        static var validBackgroundColor = "validBackgroundColor"
        static var normalBackgroundColor = "normalBackgroundColor"
        static var validationPattern = "validationPattern"
    }
    
    /// See ModelAwareControl protocol
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
    
    /// See ModelAwareControl protocol
    @IBInspectable public var realtime: Bool {
        get {
            if let rt: Bool = associatedObject(self, &AssociatedKey.realtime) {
                return rt
            }
            else{
                return false
            }
        }
        set {
            setAssociatedObject(self, newValue, &AssociatedKey.realtime, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
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
    
    /// See ModelAwareControl protocol
    public func prepare() {
        self.normalBackgroundColor = self.backgroundColor
        self.validBackgroundColor = self.backgroundColor
    }
    
    /// See ModelAwareControl protocol
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
                    valid = (value.isEmpty || value.isValidEmail())
                }
                else {
                    valid = (value.isEmpty || value.matchesRegex(validationPattern!))
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
        static var realtime = "realtime"
    }
    
    /// See ModelAwareControl protocol
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
    
    /// See ModelAwareControl protocol
    @IBInspectable public var realtime: Bool {
        get {
            if let rt: Bool = associatedObject(self, &AssociatedKey.realtime) {
                return rt
            }
            else{
                return false
            }
        }
        set {
            setAssociatedObject(self, newValue, &AssociatedKey.realtime, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        }
    }
    
    /// See ModelAwareControl protocol
    public func prepare() {
        
    }
    
    /// See ModelAwareControl protocol
    public func validate() -> Bool {
        return true
    }
}

extension UISegmentedControl: ModelAwareControl {
    
    private struct AssociatedKey {
        static var modelKeyPath = "modelKeyPath"
        static var realtime = "realtime"
        static var required = "required"
        static var errorTintColor = "errorTintColor"
        static var validTintColor = "validTintColor"
        static var normalTintColor = "normalTintColor"
    }
    
    /// See ModelAwareControl protocol
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
    
    /// See ModelAwareControl protocol
    @IBInspectable public var realtime: Bool {
        get {
            if let rt: Bool = associatedObject(self, &AssociatedKey.realtime) {
                return rt
            }
            else{
                return false
            }
        }
        set {
            setAssociatedObject(self, newValue, &AssociatedKey.realtime, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
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
    
    /// See ModelAwareControl protocol
    public func prepare() {
        self.normalTintColor = self.tintColor
        self.errorTintColor = UIColor.redColor().colorWithAlphaComponent(0.5)
        self.validTintColor = self.tintColor
    }
    
    /// See ModelAwareControl protocol
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


/**
*  Model aware UIViewController
*/
 extension UIViewController: UITextFieldDelegate, UITextViewDelegate {
    
    struct Static {
        static var onceToken : dispatch_once_t = 0
    }
    
    /**
    This initialize method is used to swizzle `viewDidLoad` and `viewWillAppear:` methods.
    
    :returns: An instance of UIViewController
    */
    override public class func initialize() {
        dispatch_once(&Static.onceToken) {
            UIViewController.swizzle()
        }
    }
    
    class func swizzle() {
//        debugPrintln("[SobrKit] Swizzling UIViewController viewDidLoad & viewWillAppear methods...")
        UIViewController.swizzleMethodSelector("viewDidLoad", withSelector: "new_viewDidLoad", forClass: UIViewController.classForCoder())
        UIViewController.swizzleMethodSelector("viewWillAppear:", withSelector: "new_viewWillAppear:", forClass: UIViewController.classForCoder())
        UIViewController.swizzleMethodSelector("viewWillDisappear:", withSelector: "new_viewWillDisappear:", forClass: UIViewController.classForCoder())
    }
    
    //MARK: - view lifecycle
    func new_viewDidLoad() {
        self.new_viewDidLoad()
        self.registerDelegates()
    }
    
    func new_viewWillAppear(animated: Bool) {
        self.new_viewWillAppear(animated)
        var controls = self.modelAwareControlsInView(self.view)
        for control in controls {
            self.setupObserving(control)
        }
        self.updateModelBindables()
    }
    
    func new_viewWillDisappear(animated: Bool) {
        self.removeObservers()
        self.new_viewWillDisappear(animated)
    }
    
    //MARK: - Helpers
    private func registerDelegates() {
        var controls = self.modelAwareControlsInView(self.view)
//        debugPrintln("[SobrKit] Found \(controls.count) model aware controls to register")
        for control in controls {
            if let keyPath = control.modelKeyPath {
//                debugPrintln("[SobrKit] Bindable keyPath: \(keyPath)")
                
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
    
    /**
    Update all ModelAwareControls for the current `UIViewController`.
    */
    public func updateModelBindables() {
        var controls = self.modelAwareControlsInView(self.view)
//        debugPrintln("[SobrKit] Updating \(controls.count) model aware controls")
        for control in controls {
            
            if let keyPath = control.modelKeyPath {
                if let value: AnyObject = self.valueForKeyPath(keyPath) {
                    self.updateControl(value, control: control)
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
    
    func controlsForModelKeyPath(keyPath: String) -> [ModelAwareControl] {
        
        var results = [ModelAwareControl]()
        
        var controls = self.modelAwareControlsInView(self.view)
//        debugPrintln("[SobrKit] Scanning \(controls.count) model aware controls for keyPath \(keyPath)...")
        
        for control in controls {
            if let controlKeyPath = control.modelKeyPath {
                if controlKeyPath == keyPath {
                    results.append(control)
                }
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
    
    func updateControl(value: AnyObject?, control: ModelAwareControl){
        if let keyPath = control.modelKeyPath {
//            debugPrintln("[SobrKit] Setting UI keyPath \(keyPath) to value: \(value)")
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
    
    func updateModel(control: ModelAwareControl) {
        if let keyPath = control.modelKeyPath {
            var value: AnyObject?
            
            if let modelAwareTextField = control as? UITextField {
                value = modelAwareTextField.text
            }
            else if let modelAwareTextView = control as? UITextView {
                value = modelAwareTextView.text
            }
            else if let modelAwareSwitch = control as? UISwitch {
                value = modelAwareSwitch.on
            }
            else if let modelAwareSegmentedControl = control as? UISegmentedControl {
                value = modelAwareSegmentedControl.selectedSegmentIndex
            }
            else if let modelAwareLabel = control as? UILabel {
                value = modelAwareLabel.text
            }
            
            if(value != nil){
                self.setValue(value, forKeyPath: keyPath)
//                debugPrintln("[SobrKit] ModelAwareControl: Did set model keyPath: \(keyPath) to value \(value!)")
            }
        }
    }
    
    //MARK: UITextFieldDelegate
    
    /**
    Tells the delegate that editing stopped for the specified text field.
    
    :param: textField The text field for which editing ended.
    */
    public func textFieldDidEndEditing(textField: UITextField) {
        textField.validate()
    }
    
    //MARK: UITextViewDelegate
    
    /**
    Tells the delegate that the text or attributes in the specified text view were changed by the user.
    
    :param: textView The text view containing the changes.
    */
    public func textViewDidChange(textView: UITextView) {
        self.valueChanged(textView)
    }
    
    /**
    Tells the delegate that editing of the specified text view has ended.
    
    :param: textView The text view in which editing ended.
    */
    public func textViewDidEndEditing(textView: UITextView) {
        textView.validate()
    }
    
    //MARK: - value changed target
    /**
    Event for value changed
    
    :param: sender Sender object
    */
    public func valueChanged(sender: AnyObject) {
        if let control = sender as? ModelAwareControl {
            self.updateModel(control)
        }
    }
    
    //MARK: - KVO
    private func setupObserving(control: ModelAwareControl) {
        if let keyPath = control.modelKeyPath {
            if control.realtime {
//                debugPrintln("[SobrKit] Setting up observer for control with keyPath \(keyPath)")
                let options = NSKeyValueObservingOptions.New | NSKeyValueObservingOptions.Old
                self.addObserver(self, forKeyPath: keyPath, options: options, context: nil)
            }
        }
    }
    
    public override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
//        debugPrintln("[SobrKit] Observed change keyPath: \(keyPath) of object: \(object)")
        
        if let value: AnyObject = self.valueForKeyPath(keyPath)  {
            var controls = self.controlsForModelKeyPath(keyPath)
            
            for control in controls {
                self.updateControl(value, control: control)
            }
        }
    }
    
    private func removeObservers() {
        var controls = self.modelAwareControlsInView(self.view)
        
        for control in controls {
            if let keyPath = control.modelKeyPath {
                if control.realtime {
//                    debugPrintln("[SobrKit] remove obersver for keyPath \(keyPath)")
                    self.removeObserver(self, forKeyPath: keyPath)
                }
            }
        }
    }
}
