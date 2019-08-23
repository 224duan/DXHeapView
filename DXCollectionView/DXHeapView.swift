//
//  DCHeapView.swift
//  DXCollectionView
//
//  Created by Duan on 2019/8/22.
//  Copyright © 2019 eric.com. All rights reserved.
//

import UIKit

class DXHeapView <T, V: UICollectionViewCell> : UIView, UICollectionViewDataSource, UICollectionViewDelegate {

    typealias TagItemActionHandler = (T) -> Void
    typealias TagConfigureItemHandler = (V, T) -> Void

    struct Config {
        var linineSpacing: CGFloat = 10
        var interitemSpacing: CGFloat = 20
        var sectionInset = UIEdgeInsets(uniform: 8)
    }

    private let cellID = "DXTagCellID"
    private let itemConfig: Config
    private var itemHandler: TagItemActionHandler?

    var items: [T] = [] { didSet { reloadDataIfNeeded() } }
    var configItemHandler: TagConfigureItemHandler? = nil { didSet { reloadDataIfNeeded() } }

    // MARK: Lifecycle
    init(_ itemConfig: Config = Config(), itemHandler: TagItemActionHandler? = nil) {
        (self.itemConfig, self.itemHandler) = (itemConfig, itemHandler)
        super.init(frame: .zero)
        initialization()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    deinit { collectionView.removeObserver(self, forKeyPath: "contentSize") }

    override func didMoveToSuperview() {
        superview?.didMoveToSuperview()
        reloadDataIfNeeded()
    }

    private func initialization() {
        addSubview(collectionView, pinningEdges: .all)
        collectionView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }

    // MARK: Override
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" { invalidateIntrinsicContentSize() }
    }

    override var intrinsicContentSize: CGSize {
        guard __CGSizeEqualToSize(collectionView.contentSize, CGSize.zero) == false else { return bounds.size }
        return collectionView.contentSize
    }

    // MARK: Components
    private lazy var collectionView: UICollectionView = {
        let result = UICollectionView(frame: bounds, collectionViewLayout: collectionFlowLayout)
        result.backgroundColor = .clear
        result.delegate = self
        result.dataSource = self
        result.isScrollEnabled = false
        result.register(V.self, forCellWithReuseIdentifier: cellID)
        return result
    }()

    private lazy var collectionFlowLayout: DXCollectionViewLeftAlignedLayout = {
        let result = DXCollectionViewLeftAlignedLayout()
        result.scrollDirection = .vertical
        result.minimumLineSpacing = itemConfig.linineSpacing
        result.minimumInteritemSpacing = itemConfig.interitemSpacing
        result.sectionInset = itemConfig.sectionInset
        result.estimatedItemSize = CGSize(width: 100, height: 60)
        return result
    }()

    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! V
        let item = items[indexPath.row]
        willConfigureCell(cell, item: item)
        configItemHandler?(cell, item)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        itemHandler?(items[indexPath.row])
    }

    // MARK: Tool
    func reloadDataIfNeeded() {
        guard superview != nil else { return }
        collectionView.reloadData()
    }

    // 将要配置 cell， 子类重写用来
    func willConfigureCell(_ cell: V, item: T) {}
}

class DXCollectionViewLeftAlignedLayout : UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let items = super.layoutAttributesForElements(in: rect) else { return nil }
        for (index, element) in items.enumerated() {
            guard index > 0, element.representedElementKind != UICollectionView.elementKindSectionHeader else { continue }
            let preElementFrame = items[index - 1].frame
            if(preElementFrame.origin.y == element.frame.origin.y) {
                element.frame.origin.x = preElementFrame.maxX + minimumInteritemSpacing
            } else {
                element.frame.origin.x = sectionInset.left
            }
        }
        return items
    }
}
