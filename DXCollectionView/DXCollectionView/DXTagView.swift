//
//  DXTagView.swift
//  DXCollectionView
//
//  Created by Duan on 2019/8/21.
//  Copyright © 2019 eric.com. All rights reserved.
//

import UIKit

final class DXTagView<T> : DXHeapView<T, DXTagCell> {

    var formatter: ((T) -> String)?

    override func willConfigureCell(_ cell: DXTagCell, item: T) {
        if formatter == nil, let text = item as? String {
            cell.titleLabel.text = text
        } else {
            cell.titleLabel.text = formatter?(item)
        }
    }
}

class DXTagCell : UICollectionViewCell {

    var cellBackgroundColor: UIColor? = .orange

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        initialization()
    }

    private func initialization() {
        backgroundColor = .clear
        contentView.addSubview(titleLabel, pinningEdges: .all, withInsets: UIEdgeInsets(horizontal: 10, vertical: 6))
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let color = cellBackgroundColor, color != UIColor.clear else { return }
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(uniform: min(rect.height, rect.width) * 0.5))
        color.setFill()
        path.fill()
    }

    private(set) lazy var titleLabel: UILabel = {
        let result = UILabel()
        result.textColor = .white
        result.font = UIFont.systemFont(ofSize: 14)
        return result
    }()
}
