import UIKit
import Foundation

typealias ActionClosure = () -> Void

/// Returns `f(x)` if `x` is non-`nil`; otherwise returns `nil`.
public func given<T, U>(_ x: T?, _ f: (T) throws -> U?) rethrows -> U? {
    guard let x = x else { return nil }
    return try f(x)
}

/// Returns `f(x!, y!)` if `x != nil && y != nil`; otherwise returns `nil`.
public func given<T, U, V>(_ x: T?, _ y: U?, _ f: (T, U) throws -> V?) rethrows -> V? {
    guard let x = x, let y = y else { return nil }
    return try f(x, y)
}

/// If `c() == true` Return f(x!); otherwise returns f(y!)
public func given<T, U>(_ c: () -> Bool, _ x: T?, _ y: T?, _ f: (T) throws -> U?) rethrows -> U? {
    let r = c() ? x : y
    return try given(r, f)
}

extension Collection {
    
    typealias Match = (Element) -> Bool
    
    func allMatch(_ match: Match) -> Bool {
        for element in self where !match(element) { return false }
        return true
    }
    
    func anyMatch(_ match: Match) -> Bool {
        for element in self where match(element) { return true }
        return false
    }
    
    func noMatch(_ match: Match) -> Bool {
        for element in self where match(element) { return false }
        return true
    }
}

extension Collection {
    
    /// Returns `self[index]` if `index` is a valid index, or `nil` otherwise.
    //    public subscript(ifValid index: Self.Index) -> Self.Iterator.Element? { get }
    
    /// Given the collection contains only exactly one element, returns it; otherwise returns `nil`.
    public var onlyElement: Self.Element? { return count == 1 ? first : nil }
    
    public var nilIfEmpty: Self? { return isEmpty ? nil : self }
}


extension UIView {
    
    @discardableResult
    @objc public func constrainHeight(to constant: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = heightAnchor.constraint(equalToConstant: constant)
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    @objc public func constrainWidth(to constant: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = widthAnchor.constraint(equalToConstant: constant)
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }
    
    @objc public func constraintSize(_ size: CGSize) {
        constrainHeight(to: size.height)
        constrainWidth(to: size.width)
    }
    
    @objc public func addSubview(_ subview: UIView, pinningEdges edges: UIRectEdge, withInsets insets: UIEdgeInsets = .zero) {
        addSubview(subview)
        subview.pinEdges(edges: edges, to: self, withInsets: insets, useSafeArea: false)
    }
    
    @objc public func addSubview(_ subview: UIView, pinningEdgesToSafeArea edges: UIRectEdge, withInsets insets: UIEdgeInsets = .zero) {
        addSubview(subview)
        subview.pinEdges(edges: edges, to: self, withInsets: insets, useSafeArea: true)
    }
    
    @discardableResult
    public func pinEdges(edges: UIRectEdge = .all, to view: UIView, withInsets insets: UIEdgeInsets = .zero, useSafeArea: Bool = true) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        let isAll = edges.contains(.all)
        var cons: [NSLayoutConstraint] = []
        if isAll || edges.contains(.top) {
            let anchor: NSLayoutYAxisAnchor
            if #available(iOS 11.0, *), useSafeArea {
                anchor = view.safeAreaLayoutGuide.topAnchor
            } else {
                anchor = view.topAnchor
            }
            cons.append(topAnchor.constraint(equalTo: anchor, constant: insets.top))
        }
        if isAll || edges.contains(.left) {
            let anchor: NSLayoutXAxisAnchor
            if #available(iOS 11.0, *), useSafeArea {
                anchor = view.safeAreaLayoutGuide.leadingAnchor
            } else {
                anchor = view.leadingAnchor
            }
            cons.append(leadingAnchor.constraint(equalTo: anchor, constant: insets.left))
        }
        if isAll || edges.contains(.bottom) {
            let anchor: NSLayoutYAxisAnchor
            if #available(iOS 11.0, *), useSafeArea {
                anchor = view.safeAreaLayoutGuide.bottomAnchor
            } else {
                anchor = view.bottomAnchor
            }
            cons.append(bottomAnchor.constraint(equalTo: anchor, constant: -insets.bottom))
        }
        if isAll || edges.contains(.right) {
            let anchor: NSLayoutXAxisAnchor
            if #available(iOS 11.0, *), useSafeArea {
                anchor = view.safeAreaLayoutGuide.trailingAnchor
            } else {
                anchor = view.trailingAnchor
            }
            cons.append(trailingAnchor.constraint(equalTo: anchor, constant: -insets.right))
        }
        NSLayoutConstraint.activate(cons)
        return cons
    }
    
    public func addSeparator(onEdges edges: UIRectEdge, thickness: CGFloat = 1 / UIScreen.main.scale, color: UIColor = UIColor.lightGray) {
        let add = {(frame: CGRect, mask: UIView.AutoresizingMask) in
            let separator = UIView(frame: frame)
            separator.backgroundColor = color
            separator.autoresizingMask = mask
            self.addSubview(separator)
            self.bringSubviewToFront(separator)
        }
        let isAll = edges.contains(.all)
        if isAll || edges.contains(.top) {
            add(CGRect(x: 0, y: 0, width: bounds.width, height: thickness), [ .flexibleBottomMargin, .flexibleWidth ])
        }
        if isAll || edges.contains(.left) {
            add(CGRect(x: 0, y: 0, width: thickness, height: bounds.height), [ .flexibleRightMargin, .flexibleHeight ])
        }
        if isAll || edges.contains(.bottom) {
            add(CGRect(x: 0, y: bounds.height - thickness, width: bounds.width, height: thickness), [ .flexibleTopMargin, .flexibleWidth ])
        }
        if isAll || edges.contains(.right) {
            add(CGRect(x: bounds.width - thickness, y: 0, width: thickness, height: bounds.height), [ .flexibleLeftMargin, .flexibleHeight ])
        }
    }
}

extension UIEdgeInsets {
    
    public init(uniform value: CGFloat) {
        self.init(top: value, left: value, bottom: value, right: value)
    }
    
    public init(horizontal horizontalInset: CGFloat = 0, vertical verticalInset: CGFloat = 0) {
        self.init(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
    }
}

extension UIButton {
    
    private static var targetVaulekey: String = "targetVaulekey"
    
    private var _tapHandler: ActionClosure? {
        set { objc_setAssociatedObject(self, &UIButton.targetVaulekey, newValue, .OBJC_ASSOCIATION_RETAIN) }
        get { return objc_getAssociatedObject(self, &UIButton.targetVaulekey) as? ActionClosure }
    }
    
    convenience init(title: String, textColor: UIColor? = nil, font: UIFont? = nil, tapHandler: ActionClosure? = nil) {
        self.init(type: .custom)
        setTitle(title, for: .normal)
        given(font) { titleLabel?.font = $0 }
        given(textColor) { setTitleColor($0, for: .normal) }
        _tapHandler = tapHandler
        if tapHandler != nil { addTarget(self, action: #selector(_tapEvent(_:)), for: .touchUpInside) }
    }
    
    @objc private func _tapEvent(_ sender: UIButton) {
        _tapHandler?()
    }
}

extension String {
    
    public func withAttributes(_ attributes: [NSAttributedString.Key : Any]) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: self, attributes: attributes)
    }
    
    public func withColor(_ color: UIColor) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: [ .foregroundColor : color ])
    }
    
    public func withStrikethrough(style: NSUnderlineStyle = .single) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: [ .underlineStyle : style ])
    }
    
    public func withLineHeight(_ lineSpacing: CGFloat) -> NSAttributedString {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        return NSAttributedString(string: self, attributes: [ .paragraphStyle : style ])
    }
    
    public func withAttributed(_ font: UIFont, color: UIColor? = nil, alignment: NSTextAlignment? = nil) -> NSMutableAttributedString {
        var attributes: [ NSAttributedString.Key : Any] = [ .font : font ]
        given(color) { attributes[ .foregroundColor ] = $0 }
        given(alignment) {
            let style = NSMutableParagraphStyle()
            style.alignment = $0
            attributes[ .paragraphStyle ] = style
        }
        return withAttributes(attributes)
    }
}

extension NSAttributedString {
    
    public func with(_ attributes: [NSAttributedString.Key : Any], range: NSRange? = nil) -> NSAttributedString {
        let result = NSMutableAttributedString(attributedString: self)
        result.addAttributes(attributes, range: range ?? NSRangeFromString(string))
        return result
    }
}

extension Int {
    
    public var nilIfZero: Int? { return self == 0 ? nil : self }
}

extension Decimal {
    
    public var nilIfZero: Decimal? { return self == 0 ? nil : self }
}

extension Date {
    
    public func formatted(using formatter: DateFormatter) -> String { return formatter.string(from: self) }
}

extension CGSize {
    
    public init(uniform value: CGFloat) {
        self.init(width: value, height: value)
    }
}

extension CGRect {
    
    public var center: CGPoint { return CGPoint(x: midX, y: midY) }
    
    public init(center: CGPoint, size: CGSize) {
        self.init(origin: CGPoint(x: center.x - size.width * 0.5, y: center.y - size.height * 0.5), size: size)
    }
}

extension UIView {
    
    open var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.masksToBounds = true; layer.cornerRadius = newValue }
    }
    
    public var borderWidth: CGFloat {
        set { layer.borderWidth = newValue }
        get { return layer.borderWidth }
    }
    
    public var borderColor: UIColor? {
        set { layer.borderColor = newValue?.cgColor }
        get { return given(layer.borderColor){ UIColor(cgColor: $0) } }
    }
}

extension UIStackView {
    
    @objc public convenience init(axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution = .fill, alignment: UIStackView.Alignment = .fill, spacing: CGFloat = 0, arrangedSubviews: [UIView] = []) {
        self.init(arrangedSubviews: arrangedSubviews)
        (self.axis, self.distribution, self.alignment, self.spacing) = (axis, distribution, alignment, spacing)
    }
}

