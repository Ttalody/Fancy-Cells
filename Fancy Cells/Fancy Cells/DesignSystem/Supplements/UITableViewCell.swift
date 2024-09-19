//
//  UITableViewCell.swift
//  Fancy Cells
//
//  Created by Artur Akulich on 19.09.24.
//

import UIKit

extension UITableViewCell {
    static var reuseID: String { .init(describing: self) }
}
