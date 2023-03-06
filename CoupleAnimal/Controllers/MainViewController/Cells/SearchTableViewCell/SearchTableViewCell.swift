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
    @IBOutlet weak var searchBar: UISearchBar!
    weak var delegate: UpdateTableView?
    var word = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let viewGesture = UITapGestureRecognizer(target: self,
                                             action: #selector(didTapContentView))
        contentView.addGestureRecognizer(viewGesture)

        searchFilterButton.layer.cornerRadius = 7
        searchFilterButton.layer.masksToBounds = true
        self.searchBar.delegate = self
        
    }

    @IBAction func searchFilterButtonDidTap(_ sender: UIButton) {
        
    }
    
    @objc func didTapContentView() {
        contentView.endEditing(true)
    }
    
    
}

extension SearchTableViewCell: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard searchText != "" || searchText != " " else {
           
            print("Emplty search")
            return
        }
        word = searchText
         
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        delegate?.searchResult(text: word)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        delegate?.searchResult(text: "")
    }
}
