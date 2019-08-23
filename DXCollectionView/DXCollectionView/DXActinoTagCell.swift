//
//  DXActinoTagCell.swift
//  DXCollectionView
//
//  Created by Duan on 2019/8/22.
//  Copyright © 2019 eric.com. All rights reserved.
//

import UIKit

class DXActinoTagCell: DXTagCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(button)
        NSLayoutConstraint.activate([
            contentView.rightAnchor.constraint(equalTo: button.centerXAnchor),
            contentView.topAnchor.constraint(equalTo: button.centerYAnchor)
            ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var button: UIButton = {
        let result = UIButton(title: "X")
        result.backgroundColor = .green
        result.constraintSize(CGSize(uniform: 20))
        return result
    }()
}
