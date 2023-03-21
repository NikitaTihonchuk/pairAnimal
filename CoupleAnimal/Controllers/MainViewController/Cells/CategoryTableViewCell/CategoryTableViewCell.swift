//
//  CategoryTableViewCell.swift
//  CoupleAnimal
//
//  Created by Nikita on 22.02.23.
//


import UIKit

class CategoryTableViewCell: UITableViewCell {
    static let id = String(describing: CategoryTableViewCell.self)

    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var petCategoryTitleLabel: UILabel!

    let mainCategoryEnumArray: [MainCategoryEnum] = MainCategoryEnum.allCases
    var selectedIndex = 0
    weak var delegate: UpdateTableView?
    override func awakeFromNib() {
        super.awakeFromNib()
        registerCell()
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
    }

 
    private func registerCell() {
        let nib = UINib(nibName: CategoryCollectionViewCell.id, bundle: nil)
        categoryCollectionView.register(nib, forCellWithReuseIdentifier: CategoryCollectionViewCell.id)
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
}

extension CategoryTableViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        selectedIndex = indexPath.row
        delegate?.update(selectedIndex: selectedIndex)
        collectionView.reloadData()

    }
    
}

extension CategoryTableViewCell: UICollectionViewDataSource {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainCategoryEnumArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let animal = mainCategoryEnumArray[indexPath.row]
        var color = hexStringToUIColor(hex: "#D7484B")
        switch animal {
        case .dogs:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.id, for: indexPath)
            guard let dogCell = cell as? CategoryCollectionViewCell else { return cell }
            dogCell.set(text: animal.name, image: UIImage(named: "dog")!)
            if selectedIndex == indexPath.row {
                dogCell.categoryBackgroundView.backgroundColor = color } else {
                dogCell.categoryBackgroundView.backgroundColor = .white }
            return dogCell
        case .cats:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.id, for: indexPath)
            guard let catCell = cell as? CategoryCollectionViewCell else { return cell }
            catCell.set(text: animal.name, image: UIImage(named: "cat")!)
            if selectedIndex == indexPath.row {
                catCell.categoryBackgroundView.backgroundColor = color } else {
                catCell.categoryBackgroundView.backgroundColor = .white }
            return catCell
        }
    }
}

extension CategoryTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 135.0, height: 60.0)
        
    }
}


