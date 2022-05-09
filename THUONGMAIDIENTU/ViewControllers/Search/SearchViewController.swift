//
//  SearchViewController.swift
//  THUONGMAIDIENTU
//
//  Created by Sang Hi Bùi on 07/03/2022.
//

import UIKit
import DropDown
import SDWebImage
import NVActivityIndicatorView

class SearchViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var dropDownClassify: UIView!
    @IBOutlet weak var nameItemOfClassify: UILabel!
    @IBOutlet weak var dropDownCategory: UIView!
    @IBOutlet weak var nameItemOfCategory: UILabel!
    @IBOutlet weak var searchProduct: UISearchBar!
    @IBOutlet weak var productsTableView: UITableView!
    @IBOutlet weak var thongBaoView: UIView!
    
    
    //MARK: - Properties
    
    var classify = DropDown()
    var category = DropDown()
    let classifyValues: [String] = ["All", "Men", "Women", "Kid"]
    let categoryValues: [String] = ["All", "Jackets & Coats", "Hoodies & Sweatshirts", "Cardigan & Jumpers", "T-shirt & Tanks", "Shoes", "Shirts", "Basics", "Blazers & Suits", "Shorts", "Trousers", "Jeans", "Swimwear", "Underwear", "Socks"]
    var products: [Product] = []
    var classifyTemp: String = ""
    var categoryTemp: String = ""
    var keywordTemp: String = ""
    
    let loading = NVActivityIndicatorView(frame: .zero, type: .lineSpinFadeLoader, color: .black, padding: 0)
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        searchProduct.delegate = self
        thongBaoView.isHidden = true
        setupDropDown()
        setupAnimation()
        setupClassify()
        setupCategory()
        setupProductsTableView()
        getProduct()
   
    }
    
    // MARK: - Setups
    
    private func setupAnimation() {
        loading.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loading)
        NSLayoutConstraint.activate([
            loading.widthAnchor.constraint(equalToConstant: 20),
            loading.heightAnchor.constraint(equalToConstant: 20),
            loading.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loading.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 15)
        ])
    }
    
    private func setupProductsTableView() {
        productsTableView.dataSource = self
        productsTableView.delegate = self
        productsTableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
        productsTableView.tableFooterView = UIView()
    }
    
    private func setupDropDown() {
        DropDown.appearance().textColor = UIColor.black
        DropDown.appearance().selectedTextColor = UIColor.black
        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 15)
        DropDown.appearance().backgroundColor = UIColor.white
        DropDown.appearance().selectionBackgroundColor = UIColor.systemGreen
        DropDown.appearance().cornerRadius = 8
    }
    
    private func setupClassify() {
        nameItemOfClassify.text = "All"
        classify.anchorView = dropDownClassify
        classify.dataSource = classifyValues
        classify.bottomOffset = CGPoint(x: 0, y:(classify.anchorView?.plainView.bounds.height)! + 5)
        classify.direction = .bottom
        /*  public func dynamicChange(height toValue: CGFloat) {
        tableView.rowHeight = toValue
         } */
        classify.dynamicChange(height: 30)
        classify.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            self.nameItemOfClassify.text = item
            if item == "All" {
                classifyTemp = ""
            } else {
                classifyTemp = item
            }
            print("Clasify now \(self.classifyTemp)")
            getProduct()
        }
        
        let gestureClassify = UITapGestureRecognizer(target: self, action: #selector(didTapClassify))
        dropDownClassify.addGestureRecognizer(gestureClassify)
        dropDownClassify.layer.borderWidth = 1
        dropDownClassify.layer.borderColor = UIColor.systemGreen.cgColor
        
    }
    
    private func setupCategory() {
        nameItemOfCategory.text = "All"
        category.anchorView = dropDownCategory
        category.dataSource = categoryValues
        category.bottomOffset = CGPoint(x: 0, y:(classify.anchorView?.plainView.bounds.height)! + 5)
        category.direction = .bottom
        category.dynamicChange(height: 30)
        category.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            self.nameItemOfCategory.text = item
            if item == "All" {
                categoryTemp = ""
            }
            if item == "Jackets & Coats" {
                categoryTemp = "jacketsCoats"
            }
            if item == "Hoodies & Sweatshirts" {
                categoryTemp = "hoodiesSweatshirts"
            }
            if item == "Cardigan & Jumpers" {
                categoryTemp = "cardiganJumpers"
            }
            if item == "T-shirt & Tanks" {
                categoryTemp = "tshirtTanks"
            }
            if item == "Shoes" {
                categoryTemp = "shoes"
            }
            if item == "Shirts" {
                categoryTemp = "shirts"
            }
            if item == "Basics" {
                categoryTemp = "basics"
            }
            if item == "Blazers & Suits" {
                categoryTemp = "blazersSuits"
            }
            if item == "Shorts" {
                categoryTemp = "shorts"
            }
            if item == "Trousers" {
                categoryTemp = "trousers"
            }
            if item == "Jeans" {
                categoryTemp = "jeans"
            }
            if item == "Swimwear" {
                categoryTemp = "swimwear"
            }
            if item == "Underwear" {
                categoryTemp = "underwear"
            }
            if item == "Socks" {
                categoryTemp = "socks"
            }
            print("Category now \(self.categoryTemp)")
            getProduct()
        }
        
        let gestureCategory = UITapGestureRecognizer(target: self, action: #selector(didTapCategory))
        dropDownCategory.addGestureRecognizer(gestureCategory)
        dropDownCategory.layer.borderWidth = 1
        dropDownCategory.layer.borderColor = UIColor.systemGreen.cgColor
    }
    
    //MARK: - Actions
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapClassify() {
        classify.show()
    }
    
    @objc func didTapCategory() {
        category.show()
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let product = products[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        cell.separatorInset = UIEdgeInsets(top: 0, left: 143, bottom: 0, right: 0)
        cell.imageProduct.sd_setImage(with: URL(string: product.images?.first?.url ?? ""), placeholderImage: UIImage(named: "imageNull"))
        cell.imageProduct.image?.imageResized(to: CGSize(width: 170, height: 277))
        cell.imageProduct.contentMode = .scaleToFill
        cell.nameProduct.text = product.name
        cell.descriptionProduct.text = product.description
        if let price = product.price {
            cell.priceProduct.text = "$ " + String(price)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 184
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = products[indexPath.row]
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let detailScreenVC = sb.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            detailScreenVC.productID = product._id ?? ""
            self.navigationController?.pushViewController(detailScreenVC, animated: true)
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.keywordTemp = searchBar.text ?? ""
        self.view.endEditing(true)
        getProduct()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.keywordTemp = searchBar.text ?? ""
        print(self.keywordTemp)
        getProduct()
    }
}

//Call API
extension SearchViewController {
    
    // Call api get Product theo bộ lọc
    private func getProduct() {
        loading.startAnimating()
        APIService.getExploreProducts(with: .getProductExplore, keyword:  keywordTemp , category: categoryTemp, classify:  classifyTemp) { exploreProducts, error in
            self.loading.stopAnimating()
            guard let exploreProducts = exploreProducts, let products = exploreProducts.products  else { return }
            DispatchQueue.main.async {
                self.products = products
                if products.isEmpty {
                    self.thongBaoView.isHidden = false
                    self.productsTableView.isHidden = true
                } else {
                    self.thongBaoView.isHidden = true
                    self.productsTableView.isHidden = false
                }
                print("Search Product: \(self.products)")
                self.productsTableView.reloadData()
            }
        }
    }
}
