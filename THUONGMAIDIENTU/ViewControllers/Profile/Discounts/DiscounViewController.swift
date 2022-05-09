//
//  DiscountViewViewController.swift
//  THUONGMAIDIENTU
//
//  Created by Sang Hi Bùi on 20/04/2022.
//

import UIKit

class DiscounViewController: UIViewController {
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var searchDiscount: UISearchBar!
    @IBOutlet weak var discountTableView: UITableView!
    
    //MARK: - Properties
    
    var listDiscount: [DiscountItem] = []
    var keywordTemp = ""

    //MARK: - LifeCycels
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getListDiscount()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchDiscount.delegate = self
        setupDiscountTableView()
    }
    
    private func setupDiscountTableView() {
        discountTableView.delegate = self
        discountTableView.dataSource = self
        discountTableView.register(UINib(nibName: "DiscountTableViewCell", bundle: nil), forCellReuseIdentifier: "DiscountTableViewCell")
        discountTableView.tableFooterView = UIView()
    }
    
    func formatDate(date: String) -> String {
       let dateFormatterGet = DateFormatter()
       dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
   
       let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd-MM-yyyy HH:mm"

       let dateAfter: Date? = dateFormatterGet.date(from: date)

       return dateFormatterPrint.string(from: dateAfter!)
    }
}

extension DiscounViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listDiscount.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let discount = listDiscount[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiscountTableViewCell", for: indexPath) as! DiscountTableViewCell
        cell.sttDiscount.text = "DISCOUNT " + String(indexPath.row + 1)
        cell.nameDiscount.text = discount.name
        let value = discount.value ?? 0
        cell.valueDiscount.text = String(value)
        let quantity = discount.quantity ?? 0
        cell.quantityDiscount.text = String(quantity)
        cell.categoryDiscount.text = discount.categoryProduct
        let createAt = discount.createAt ?? ""
        cell.createAtDiscount.text = formatDate(date: createAt)
        let validDate = discount.validDate ?? ""
        cell.validDateDiscount.text = formatDate(date: validDate)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

//Call API
extension DiscounViewController {
    private func getListDiscount() {
        APIService.getDiscountCode(with: keywordTemp) { listDiscount, error in
            print("keywordTemp: \(self.keywordTemp)")
            guard let discounts = listDiscount?.discounts else { return }
            DispatchQueue.main.async {
                self.listDiscount = discounts
                self.discountTableView.reloadData()
            }
        }
    }
}

extension DiscounViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.keywordTemp = searchBar.text ?? ""
        self.view.endEditing(true)
        getListDiscount()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.keywordTemp = searchBar.text ?? ""
        print(self.keywordTemp)
        getListDiscount()
    }
}
