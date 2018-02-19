//
//  TeamProfilesCollectionViewLayout.swift
//  SoFiProject
//
//  Created by Keaton Harward on 2/18/18.
//  Copyright © 2018 Keaton Harward. All rights reserved.
//

import UIKit

fileprivate let cellPadding = 10.0
fileprivate let numberOfColumns = 3.0

class TeamProfilesCollectionViewLayout: UICollectionViewLayout {
    
    var largeCellIndex = IndexPath(item: 0, section: 0)
    var contentSize = CGSize.zero
    var cellAttributesDictionary = [IndexPath : UICollectionViewLayoutAttributes]()
    
    override var collectionViewContentSize: CGSize {
        return self.contentSize
    }

    override func prepare() {
        guard let collectionView = collectionView else { return }
        
        let cellDimensions = ((Double(collectionView.frame.width) - (cellPadding * (numberOfColumns + 1))) / numberOfColumns)
        let contentHeight = (((Double(collectionView.numberOfItems(inSection: 0) - 1) / numberOfColumns) + 1) * cellDimensions) + (Double(collectionView.numberOfItems(inSection: 0)) * cellPadding)
        
        contentSize = CGSize(width: Double(collectionView.frame.width), height: contentHeight)
        
        if collectionView.numberOfItems(inSection: 0) > 0 {
            for item in 0...collectionView.numberOfItems(inSection: 0) - 1 {
                let cellIndex = IndexPath(item: item, section: 0)
                let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: cellIndex)
                
                // TODO: - update this for selected cells in different rows & columns
                if cellIndex == largeCellIndex {
                    cellAttributes.frame = CGRect(x: cellPadding, y: cellPadding, width: ((cellDimensions * 2) + cellPadding), height: ((cellDimensions * 2) + cellPadding))
                    cellAttributesDictionary[cellIndex] = cellAttributes
                } else if cellIndex == IndexPath(item: 1, section: 0) {
                    cellAttributes.frame = CGRect(x: (cellPadding * 3) + (cellDimensions * 2), y: cellPadding, width: cellDimensions, height: cellDimensions)
                    cellAttributesDictionary[cellIndex] = cellAttributes
                } else if cellIndex == IndexPath(item: 2, section: 0) {
                    cellAttributes.frame = CGRect(x: (cellPadding * 3) + (cellDimensions * 2), y: ((cellPadding * 2) + cellDimensions), width: cellDimensions, height: cellDimensions)
                    cellAttributesDictionary[cellIndex] = cellAttributes
                } else {
                    let row = item / Int(numberOfColumns) + 1
                    let yPosition = ((Double(row)) * cellDimensions) + ((Double(row) + 1) * cellPadding)
                    var xPosition = 0.0
                    switch item % 3 {
                    case 0: xPosition = cellPadding
                    case 1: xPosition = (cellPadding * 2) + cellDimensions
                    case 2: xPosition = (cellPadding * 3) + (cellDimensions * 2)
                    default: break
                    }
                    
                    cellAttributes.frame = CGRect(x: xPosition, y: yPosition, width: cellDimensions, height: cellDimensions)
                cellAttributesDictionary[cellIndex] = cellAttributes
                }
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributesInRect = [UICollectionViewLayoutAttributes]()
        
        for cellAttributes in cellAttributesDictionary.values {
            attributesInRect.append(cellAttributes)
        }
        return attributesInRect
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cellAttributesDictionary[indexPath]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
