//
//  SearchTableViewCell.swift
//  CoupleAnimal
//
//  Created by Nikita on 22.02.23.
//

import UIKit

//уточнить у ильи как работает поиск и как его сделать нормальным цветом

class SearchTableViewCell: UITableViewCell {
    
    
    static let id = String(describing: SearchTableViewCell.self)
    
    @IBOutlet weak var searchFilterButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        searchFilterButton.layer.cornerRadius = 7
        searchFilterButton.layer.masksToBounds = true

    }

    @IBAction func searchFilterButtonDidTap(_ sender: UIButton) {
    }
    
    
}
