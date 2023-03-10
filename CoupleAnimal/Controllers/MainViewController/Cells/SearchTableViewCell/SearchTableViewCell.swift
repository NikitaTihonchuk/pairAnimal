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
        self.searchBar.translatesAutoresizingMaskIntoConstraints = false
        self.searchBar.delegate = self
        textFieldSubviews()
    }
    
    func textFieldSubviews() {
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .white
            
            guard let backgroundView = textField.subviews.first else { return }
            if #available(iOS 11.0, *) {
                backgroundView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
                backgroundView.subviews.forEach({ $0.removeFromSuperview() })
            }
            backgroundView.layer.masksToBounds = true
        }
    }
    
    @objc func didTapContentView() {
        contentView.endEditing(true)
    }
    
    
}

extension SearchTableViewCell: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard searchText != "" || searchText != " " else {
           
            print("Empty search")
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
    //
}


