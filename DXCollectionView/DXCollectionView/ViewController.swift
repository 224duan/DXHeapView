//
//  ViewController.swift
//  DXCollectionView
//
//  Created by Duan on 2019/8/21.
//  Copyright © 2019 eric.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private lazy var tagView: DXTagView<Int> = DXTagView() { value in
        print("value is \(value)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addTag()

//        UIView.noIntrinsicMetric
        view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)

//        tagView.backgroundColor = .lightGray
//
//        var array: [Int] = []
//        for i in 0...30 {
//            array.append(i)
//        }
//        tagView.items = array
//        tagView.formatter = { return "index = \($0)" }
//        view.addSubview(tagView, pinningEdgesToSafeArea: [ .top, .left, .right ])
//
//        let red = UIView()
//        red.backgroundColor = .red
//        red.constraintSize(CGSize(uniform: 40))
//        view.addSubview(red, pinningEdges: .left)
//        red.topAnchor.constraint(equalTo: tagView.bottomAnchor).isActive = true

    }

    func addTag() {
        let heapView = DXHeapView<String, DXActinoTagCell>() { print("click \($0)") }
        heapView.backgroundColor = .blue
        heapView.items = ["- aasd -","- adf -","- aadfadf -","- aasdf -","- as -","- afad -","- a -"]
        heapView.configItemHandler = { (cell, item) in
            cell.titleLabel.text = item
        }

        view.addSubview(heapView, pinningEdgesToSafeArea: [ .top, .left, .right ])
    }

}


/*
 //        contentView.addSubview(titleLabel)
 //        titleLabel.bounds = CGRect(x: 0, y: 0, width: contentView.frame.width - 20, height: contentView.frame.height)
 //        titleLabel.center = contentView.bounds.center
 //        titleLabel.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]


 //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
 //        guard let title = title(with: indexPath.row) as NSString? else { return .zero }
 //        var size = title.boundingRect(with: CGSize(uniform: CGFloat.greatestFiniteMagnitude), options: .usesFontLeading, attributes: [ .font : UIFont.systemFont(ofSize: 14) ], context: nil).size
 //        size.width += 22
 //        return size
 //    }

 */

