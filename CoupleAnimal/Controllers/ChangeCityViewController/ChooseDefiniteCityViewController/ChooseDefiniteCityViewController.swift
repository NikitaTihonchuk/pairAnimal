//
//  ChooseDefiniteCityViewController.swift
//  CoupleAnimal
//
//  Created by Nikita on 5.03.23.
//

import UIKit

class ChooseDefiniteCityViewController: UIViewController {

    
    @IBOutlet weak var definiteCityTableView: UITableView!
    
    var citys = [String]()
    var country: String? = nil
    
    weak var delegate: CityProtocol?
    
    var cityArray = [String]() {
        didSet {
            definiteCityTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        definiteCityTableView.dataSource = self
        definiteCityTableView.delegate = self
        cityArray = citys
    }
    
    func getCity(allCitys: [String:Any]) {
        for city in allCitys.keys {
            citys.append(city)
        }
    }
    
    private func registerCell() {
        let nib = UINib(nibName: ChooseDefiniteCityTableViewCell.id, bundle: nil)
        definiteCityTableView.register(nib, forCellReuseIdentifier: ChooseDefiniteCityTableViewCell.id)
    }
    
    
}

extension ChooseDefiniteCityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = cityArray[indexPath.row]
        self.dismiss(animated: true)
        guard let country = country else { return }
        delegate?.update(text: "\(country), \(city)")
    }
}

extension ChooseDefiniteCityViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChooseDefiniteCityTableViewCell.id, for: indexPath)
        guard let cityCell = cell as? ChooseDefiniteCityTableViewCell else { return cell }
        cityCell.set(city: cityArray[indexPath.row])
        return cityCell
    }
    
    
}
