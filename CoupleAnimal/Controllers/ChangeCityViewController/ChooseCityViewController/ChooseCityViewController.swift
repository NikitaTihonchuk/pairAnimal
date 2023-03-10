//
//  ChooseCityViewController.swift
//  CoupleAnimal
//
//  Created by Nikita on 5.03.23.
//

import UIKit

class ChooseCityViewController: UIViewController, CityProtocol {
    
    @IBOutlet weak var cityTableView: UITableView!
    
    weak var delegate: CityProtocol?
    
    var country = [String]() {
        didSet {
            cityTableView.reloadData()
        }
    }
    
    var city: String? = nil {
        didSet {
            self.dismiss(animated: true)
            delegate?.update(text: city!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        getCountry()
        cityTableView.delegate = self
        cityTableView.dataSource = self
    }

    private func registerCell() {
        let nib = UINib(nibName: ChooseCityTableViewCell.id, bundle: nil)
        cityTableView.register(nib, forCellReuseIdentifier: ChooseCityTableViewCell.id)
    }
    
    func update(text: String) {
        self.city = text
    }
    
    private func getCountry() {
        DatabaseManager.shared.readCountry { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let success):
                for country in success.keys {
                    strongSelf.country.append(country)
                }
            case .failure(let error):
                print(error)
            }
        }
    }


}


extension ChooseCityViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country = country[indexPath.row]
        
        DatabaseManager.shared.readCity(nameCountry: country) { result in
            switch result {
            case .success(let success):
                let vc = ChooseDefiniteCityViewController(nibName: "ChooseDefiniteCityViewController", bundle: nil)
                vc.delegate = self
                vc.country = country
                vc.getCity(allCitys: success)
                self.present(vc, animated: true)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
}

extension ChooseCityViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return country.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChooseCityTableViewCell.id, for: indexPath)
        guard let countryCell = cell as? ChooseCityTableViewCell else { return cell }
        countryCell.setLabel(city: country[indexPath.row])
        return countryCell
    }
    
    
}

protocol CityProtocol: UIViewController {
    func update(text: String)
}


