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
    
    @IBOutlet weak var searchWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchFilterButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    weak var delegate: UpdateTableView?
    var word = ""
    var grow: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let viewGesture = UITapGestureRecognizer(target: self,
                                             action: #selector(didTapContentView))
        contentView.addGestureRecognizer(viewGesture)
        searchTextField.layer.masksToBounds = true
        searchTextField.layer.cornerRadius = 25

        searchFilterButton.layer.cornerRadius = 15
        searchFilterButton.layer.masksToBounds = true
        
        searchTextField.delegate = self
        searchButton.isHidden = true

    }
    
    func animateGrowShrinkTextFields(grow: Bool) {
        if grow {
            UIView.animate(withDuration: 0.3, animations: {
                self.searchWidthConstraint.constant = 0
                self.layoutIfNeeded()
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.searchWidthConstraint.constant = 90.0
                self.layoutIfNeeded()
            })
        }
    }
    
    @objc func didTapContentView() {
        contentView.endEditing(true)
    }
    
    @IBAction func searchButtonDidTap(_ sender: UIButton) {
        grow = true
        searchButton.isHidden = true
        animateGrowShrinkTextFields(grow: grow)
        contentView.endEditing(true)
        guard let searchText = searchTextField.text else { return }
        delegate?.searchResult(text: searchText)
    }
    
    
    
    @IBAction func searchFilterButtonDidTap(_ sender: UIButton) {
        
    }
    
    
}

extension SearchTableViewCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        grow = false
        searchButton.isHidden = false
        animateGrowShrinkTextFields(grow: grow)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        grow = false
        searchButton.isHidden = false
        animateGrowShrinkTextFields(grow: grow)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        grow = true
        searchButton.isHidden = true
        animateGrowShrinkTextFields(grow: grow)
    }
}


