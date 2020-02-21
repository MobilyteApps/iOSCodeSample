//
//  CGRect+Ex.swift
//  Projectart
//
//  Created by Sunil Garg on 20/05/19.
//  Copyright © 2019 Sunil Garg. All rights reserved.
//
import UIKit

//MARK:-EXTENTION FOR CGRECT USING FOR CUSTOME LOADER(TRANSITIONSUBMIT BUTTON)
extension CGRect {
    var x: CGFloat {
        get {
            return self.origin.x
        }
        set {
            self = CGRect(x: newValue, y: self.y, width: self.width, height: self.height)
        }
    }
    
    var y: CGFloat {
        get {
            return self.origin.y
        }
        set {
            self = CGRect(x: self.x, y: newValue, width: self.width, height: self.height)
        }
    }
    
    var width: CGFloat {
        get {
            return self.size.width
        }
        set {
            self = CGRect(x: self.x, y: self.y, width: newValue, height: self.height)
        }
    }
    
    var height: CGFloat {
        get {
            return self.size.height
        }
        set {
            self = CGRect(x: self.x, y: self.y, width: self.width, height: newValue)
        }
    }
    
    
    var top: CGFloat {
        get {
            return self.origin.y
        }
        set {
            y = newValue
        }
    }
    
    var bottom: CGFloat {
        get {
            return self.origin.y + self.size.height
        }
        set {
            self = CGRect(x: x, y: newValue - height, width: width, height: height)
        }
    }
    
    var left: CGFloat {
        get {
            return self.origin.x
        }
        set {
            self.x = newValue
        }
    }
    
    var right: CGFloat {
        get {
            return x + width
        }
        set {
            self = CGRect(x: newValue - width, y: y, width: width, height: height)
        }
    }
    
    
    var midX: CGFloat {
        get {
            return self.x + self.width / 2
        }
        set {
            self = CGRect(x: newValue - width / 2, y: y, width: width, height: height)
        }
    }
    
    var midY: CGFloat {
        get {
            return self.y + self.height / 2
        }
        set {
            self = CGRect(x: x, y: newValue - height / 2, width: width, height: height)
        }
    }
    
    
    var center: CGPoint {
        get {
            return CGPoint(x: self.midX, y: self.midY)
        }
        set {
            self = CGRect(x: newValue.x - width / 2, y: newValue.y - height / 2, width: width, height: height)
        }
    }
}


//MARK:- EXTENSION FOR Int
extension Int {
    var stringValue:  String     {  return NSNumber(value: self).stringValue  }
    var int8Value:    Int8       {  return NSNumber(value: self).int8Value    }
    var int16Value:   Int16      {  return NSNumber(value: self).int16Value   }
    var int32Value:   Int32      {  return NSNumber(value: self).int32Value   }
    var int64Value:   Int64      {  return NSNumber(value: self).int64Value   }
    var floatValue:   Float      {  return NSNumber(value: self).floatValue   }
    var doubleValue:  Double     {  return NSNumber(value: self).doubleValue  }
    var boolValue:    Bool       {  return NSNumber(value: self).boolValue    }
    var decimalValue: Decimal    {  return NSNumber(value: self).decimalValue }
    
}
//MARK:- EXTENSION FOR Float
extension Float {
    
    var stringValue:  String     {  return NSNumber(value: self).stringValue  }
    var intValue:     Int        {  return NSNumber(value: self).intValue     }
    var int8Value:    Int8       {  return NSNumber(value: self).int8Value    }
    var int16Value:   Int16      {  return NSNumber(value: self).int16Value   }
    var int32Value:   Int32      {  return NSNumber(value: self).int32Value   }
    var int64Value:   Int64      {  return NSNumber(value: self).int64Value   }
    var doubleValue:  Double     {  return NSNumber(value: self).doubleValue  }
    var boolValue:    Bool       {  return NSNumber(value: self).boolValue    }
    var decimalValue: Decimal    {  return NSNumber(value: self).decimalValue }
}
//MARK:- EXTENSION FOR Double
extension Double {
    
    var stringValue:  String     {  return NSNumber(value: self).stringValue  }
    var intValue:     Int        {  return NSNumber(value: self).intValue     }
    var int8Value:    Int8       {  return NSNumber(value: self).int8Value    }
    var int16Value:   Int16      {  return NSNumber(value: self).int16Value   }
    var int32Value:   Int32      {  return NSNumber(value: self).int32Value   }
    var int64Value:   Int64      {  return NSNumber(value: self).int64Value   }
    var floatValue:   Float      {  return NSNumber(value: self).floatValue   }
    var boolValue:    Bool       {  return NSNumber(value: self).boolValue    }
    var decimalValue: Decimal    {  return NSNumber(value: self).decimalValue }
    
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

//MARK:- EXTENSION FOR Bool
extension Bool {
    var stringValue:  String     {  return NSNumber(value: self).stringValue  }
    var intValue:     Int        {  return NSNumber(value: self).intValue     }
    
}




