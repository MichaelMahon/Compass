//
//  UIView+Extension.swift

//
//  Created by Liu Chuan on 2018/4/7.
//  Copyright © 2018年 LC. All rights reserved.
//

import UIKit

/// Screen height
public let screenH: CGFloat = UIScreen.main.bounds.height


// MARK: - Extend UIView
extension UIView {

    /// View's X value
    var LeftX: CGFloat {
        get {
            return self.frame.origin.x
        }
    }
    /// The X value to the right of the view
    var RightX: CGFloat {
        get {
            return self.frame.origin.x + self.bounds.width
        }
    }
    /// View top Y value
    var TopY: CGFloat {
        get {
            return self.frame.origin.y
        }
    }
    /// View bottom Y value
    var BottomY: CGFloat {
        get {
            return self.frame.origin.y + self.bounds.height
        }
    }

    /// Width of the view
    var Width: CGFloat {
        get {
            return self.bounds.width
        }
    }

    /// Height of view
    var Height: CGFloat {
        get {
            return self.bounds.height
        }
    }
}
