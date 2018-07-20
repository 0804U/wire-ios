//
// Wire
// Copyright (C) 2018 Wire Swiss GmbH
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see http://www.gnu.org/licenses/.
//

import Foundation

class UpsideDownTableView: UITableView {
    override init(frame: CGRect, style: UITableViewStyle) {
        isKeyboardDismissing = false

        super.init(frame: frame, style: style)

        UIView.performWithoutAnimation({
            self.transform = CGAffineTransform(scaleX: 1, y: -1)
        })

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardMoved), name: .UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardMoved), name: .UIKeyboardDidChangeFrame, object: nil)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc fileprivate func keyboardMoved() {
        isKeyboardDismissing = false
    }

    @objc public var correctedContentInset: UIEdgeInsets {
        get {
            let insets = super.contentInset
            return UIEdgeInsetsMake(insets.bottom, insets.left, insets.top, insets.right)
        }

        set {
            super.contentInset = UIEdgeInsetsMake(contentInset.bottom, contentInset.left, contentInset.top, contentInset.right)
        }
    }

    public var correctedScrollIndicatorInsets: UIEdgeInsets {
        get {
            let insets = super.scrollIndicatorInsets
            return UIEdgeInsetsMake(insets.bottom, insets.left, insets.top, insets.right)
        }

        set {
            super.scrollIndicatorInsets = UIEdgeInsetsMake(correctedScrollIndicatorInsets.bottom, correctedScrollIndicatorInsets.left, correctedScrollIndicatorInsets.top, correctedScrollIndicatorInsets.right)
        }
    }

    @objc public var isKeyboardDismissing: Bool

    override var contentOffset: CGPoint {
        get {
            return super.contentOffset
        }

        set {
            guard !self.isKeyboardDismissing else { return }

            ///TODO called by [UIScrollView _updatePanGesture]
            super.contentOffset = newValue
        }
    }

    override var tableHeaderView: UIView? {
        get {
            return super.tableFooterView
        }

        set(tableHeaderView) {
            tableHeaderView?.transform = CGAffineTransform(scaleX: 1, y: -1)
            super.tableFooterView = tableHeaderView
        }
    }

    override var tableFooterView: UIView? {
        get {
            return super.tableHeaderView
        }

        set(tableFooterView) {
            tableFooterView?.transform = CGAffineTransform(scaleX: 1, y: -1)
            super.tableHeaderView = tableFooterView
        }
    }

    override func dequeueReusableCell(withIdentifier identifier: String) -> UITableViewCell? {
        let cell = super.dequeueReusableCell(withIdentifier: identifier)
        cell?.transform = CGAffineTransform(scaleX: 1, y: -1)
        return cell
    }

    override func scrollToNearestSelectedRow(at scrollPosition: UITableViewScrollPosition, animated: Bool) {
        super.scrollToNearestSelectedRow(at: inverseScrollPosition(scrollPosition), animated: animated)
    }

    override func scrollToRow(at indexPath: IndexPath, at scrollPosition: UITableViewScrollPosition, animated: Bool) {
        super.scrollToRow(at: indexPath, at: inverseScrollPosition(scrollPosition), animated: animated)
    }

    override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
        let cell = super.dequeueReusableCell(withIdentifier: identifier, for: indexPath)

        cell.transform = CGAffineTransform(scaleX: 1, y: -1)

        return cell
    }

    func inverseScrollPosition(_ scrollPosition: UITableViewScrollPosition) -> UITableViewScrollPosition {
        if scrollPosition == .top {
            return .bottom
        } else if scrollPosition == .bottom {
            return .top
        } else {
            return scrollPosition
        }
    }
}
