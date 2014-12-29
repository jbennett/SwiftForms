//
//  FormRowDescriptor.swift
//  SwiftForms
//
//  Created by Miguel Angel Ortuno on 20/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

import UIKit

enum FormRowType {
    case Unknown
    case Text
    case URL
    case Number
    case NumbersAndPunctuation
    case Decimal
    case Name
    case Phone
    case NamePhone
    case Email
    case Twitter
    case ASCIICapable
    case Password
    case Button
    case BooleanSwitch
    case BooleanCheck
    case SegmentedControl
    case Picker
    case Date
    case Time
    case DateAndTime
    case MultipleSelector
    case MultilineText
  
    func classForRowType() -> FormBaseCell.Type {
        switch self {
        case .Text, .Number, .NumbersAndPunctuation, .Decimal,
        .Name, .Phone, .URL, .Twitter, .NamePhone, .Email, .ASCIICapable,
        .Password, .MultilineText:
            return FormTextFieldCell.self
        case .Button:
            return FormButtonCell.self
        case .BooleanSwitch:
            return FormSwitchCell.self
        case .BooleanCheck:
            return FormCheckCell.self
        case .SegmentedControl:
            return FormSegmentedControlCell.self
        case .Picker:
            return FormPickerCell.self
        case .Date, .Time, .DateAndTime:
            return FormDateCell.self
        case .MultipleSelector:
            return FormSelectorCell.self
        case .Unknown:
            assert(false, "Error: Unknown cell type")
            return FormTextFieldCell.self
        }
    }
}

typealias TitleFormatter = (NSObject) -> String!

class FormRowDescriptor: NSObject {

    /// MARK: Properties
    
    var title: String!
    var rowType: FormRowType = .Unknown
    var tag: String!

    var value: NSObject! {
        willSet {
            self.willUpdateValueBlock?(self)
        }
        didSet {
            self.didUpdateValueBlock?(self)
        }
    }
    
    var required = true
    
    var cellClass: AnyClass!
    var cellAccessoryView: UIView!
    var placeholder: String!
    
    var cellConfiguration: NSDictionary!
    
    var willUpdateValueBlock: ((FormRowDescriptor) -> Void)!
    var didUpdateValueBlock: ((FormRowDescriptor) -> Void)!
    
    var visualConstraintsBlock: ((FormBaseCell) -> NSArray)!
    
    var options: NSArray!
    var titleFormatter: TitleFormatter!
    var selectorControllerClass: AnyClass!
    var allowsMultipleSelection = false
    
    var showInputToolbar = false
    var dateFormatter: NSDateFormatter!
    
    var userInfo: NSDictionary!
    
    /// MARK: Init
    
    init(tag: String, rowType: FormRowType, title: String, placeholder: String! = nil) {
        self.tag = tag
        self.rowType = rowType
        self.title = title
        self.placeholder = placeholder
    }
    
    /// MARK: Public interface
    
    func titleForOptionAtIndex(index: Int) -> String! {
        return titleForOptionValue(options[index] as NSObject)
    }
    
    func titleForOptionValue(optionValue: NSObject) -> String! {
        if titleFormatter != nil {
            return titleFormatter(optionValue)
        }
        else if optionValue is String {
            return optionValue as String
        }
        return "\(optionValue)"
    }
}
