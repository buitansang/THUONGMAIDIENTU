//
//  OrderNowViewController.swift
//  THUONGMAIDIENTU
//
//  Created by Sang Hi Bùi on 22/04/2022.
//

import UIKit
import NVActivityIndicatorView

protocol DetailDelegate: class {
    func infoAddress(_ address: String, _ city: String, _ phoneNo: String, _ postalCode: String, _ country: String)
}

class OrderNowViewController: UIViewController, UIGestureRecognizerDelegate, DetailDelegate {
    
    //MARK: - Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cartProduct: UITableView!
    @IBOutlet weak var itemsPrice: UILabel!
    @IBOutlet weak var taxPrice: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var discountCode: UITextField!
    @IBOutlet weak var shipping: UIView!
    @IBOutlet weak var shippingInfoView: UIView!
    @IBOutlet weak var buyButton: UIButton!
    
    //MARK: - Properties
    
    var nameItem = ""
    var priceItem = 0.0
    var quantity = 0
    var categoryItem = ""
    var image = ""
    var productID = ""
    var address = ""
    var city = ""
    var phoneNo = ""
    var postalCode = ""
    var country = ""
    var itemsPriceNumber = 0.0
    
    let loadingBuy = NVActivityIndicatorView(frame: .zero, type: .lineSpinFadeLoader, color: .white, padding: 0)
    private let viewAnimateBuy: UIView = {
        let view = UIView()
        view.frame = .zero
        view.backgroundColor = .lightGray
        return view
    }()
    
    //MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        backButton()
        tapDoneButton()
        setupShipping()
        setupViewAnimateBuy()
        setupAnimationBuy()
        title = "Cart"
    }
    
    //MARK: - Setups
    
    func infoAddress(_ address: String, _ city: String, _ phoneNo: String, _ postalCode: String, _ country: String) {
        self.address = address
        self.city = city
        self.phoneNo = phoneNo
        self.postalCode = postalCode
        self.country = country
    }
    
    private func setupShipping() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapShipping))
        shipping.addGestureRecognizer(gesture)
    }
    
    private func setupViewAnimateBuy() {
        viewAnimateBuy.isHidden = true
        viewAnimateBuy.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewAnimateBuy)
        NSLayoutConstraint.activate([
            viewAnimateBuy.widthAnchor.constraint(equalToConstant: 70),
            viewAnimateBuy.heightAnchor.constraint(equalToConstant: 70),
            viewAnimateBuy.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewAnimateBuy.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupAnimationBuy() {
        loadingBuy.translatesAutoresizingMaskIntoConstraints = false
        viewAnimateBuy.addSubview(loadingBuy)
        NSLayoutConstraint.activate([
            loadingBuy.widthAnchor.constraint(equalToConstant: 30),
            loadingBuy.heightAnchor.constraint(equalToConstant: 30),
            loadingBuy.centerXAnchor.constraint(equalTo: viewAnimateBuy.centerXAnchor),
            loadingBuy.centerYAnchor.constraint(equalTo: viewAnimateBuy.centerYAnchor)
        ])
        loadingBuy.startAnimating()
    }
    
    private func itemBuyProduct() -> [[String: Any]] {
        return [
            [
                "quantity" : self.quantity,
                "checked" : 1,
                "name" : nameItem,
                "image" : image,
                "price" : self.priceItem,
                "product" : productID,
                "category" : self.categoryItem,
                "total" : Double(self.quantity ?? 0) * self.priceItem
            ]
       ]
    }
    
    private func setupUI() {
        shippingInfoView.layer.borderWidth = 1
        shippingInfoView.layer.cornerRadius = 5
        shippingInfoView.layer.borderColor = UIColor.systemGreen.cgColor
        buyButton.layer.cornerRadius = 12
    }
    
    private func backButton() {
        let backButton: UIButton = UIButton()
        backButton.setImage(UIImage(named: "backButton"), for: .normal)
        backButton.sizeToFit()
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = leftBarButton
       
    }
    
    private func tapDoneButton() {
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "done", style: .done, target: self, action: #selector(didTapOnView))
        ]
        toolbar.sizeToFit()
        discountCode.inputAccessoryView = toolbar
        discountCode.keyboardType = .numberPad
    }
    
    private func setupTableView() {
        cartProduct.dataSource = self
        cartProduct.delegate = self
        cartProduct.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "CartTableViewCell")
        cartProduct.tableFooterView = UIView()
    }
    
    @objc func didTapShipping() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let editAddressVC = sb.instantiateViewController(withIdentifier: "EditAddressViewController") as! EditAddressViewController
        editAddressVC.delegate = self
        self.present(editAddressVC, animated: true, completion: nil)
    }
    
    @objc func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapOnView() {
        view.endEditing(true)
    }
    //MARK: - Actions
    
    @IBAction func didTapBuyButton() {
        
        if (address.count<=0) || (city.count<=0) || (phoneNo.count<=0) || (country.count<=0) || (postalCode.count<=0) {
            let alert = UIAlertController(title: "Shipping info is empty!!!", message: "Please input shipping info.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            
            createOrder()
        }
    }
}

extension OrderNowViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell
        cell.quantityProduct.text = String(self.quantity)
        cell.nameProduct.text = nameItem
        cell.price.text = String(self.priceItem) + " $"
        cell.total.text = String(Double(quantity) * priceItem) + " $"
        cell.imageProduct.sd_setImage(with: URL(string: self.image ?? ""), placeholderImage: UIImage(named: "imageNull"))
        cell.imageProduct.image?.imageResized(to: CGSize(width: 110, height: 130))
        cell.imageProduct.contentMode = .scaleToFill
        cell.checkBox.image = UIImage(named: "check")
        
        let tempTotal = Double(quantity) * priceItem
        self.itemsPriceNumber = tempTotal
        cell.total.text = String(tempTotal) + " $"
        itemsPrice.text = String(tempTotal) + " $"
        taxPrice.text = String(tempTotal / 10) + " $"
        totalPrice.text = String(tempTotal + tempTotal / 10 + 2.0) + " $"
        
        let gestureMinus : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapOnMinus(tapGesture:)))
        gestureMinus.delegate = self
        gestureMinus.numberOfTapsRequired = 1
        cell.viewOfMinus.isUserInteractionEnabled = true
        cell.viewOfMinus.tag = indexPath.row
        cell.viewOfMinus.addGestureRecognizer(gestureMinus)
        
        let gesturePlus : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapOnPlus(tapGesture:)))
        gesturePlus.delegate = self
        gesturePlus.numberOfTapsRequired = 1
        cell.viewOfPlus.isUserInteractionEnabled = true
        cell.viewOfPlus.tag = indexPath.row
        cell.viewOfPlus.addGestureRecognizer(gesturePlus)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    @objc func tapOnMinus(tapGesture:UITapGestureRecognizer) {
        let indexPath = NSIndexPath(row: tapGesture.view!.tag, section: 0)
        guard let cell = cartProduct.cellForRow(at: indexPath as IndexPath) as? CartTableViewCell else { return }
        var tempQuantity = 0
        tempQuantity = Int(cell.quantityProduct.text ?? "0") ?? 0
        tempQuantity = (tempQuantity) - 1
        if tempQuantity > 0 {
            cell.quantityProduct.text = String(tempQuantity)
            let tempTotal = Double(tempQuantity) * priceItem
            self.itemsPriceNumber = tempTotal
            cell.total.text = String(tempTotal) + " $"
            itemsPrice.text = String(tempTotal) + " $"
            taxPrice.text = String(tempTotal / 10) + " $"
            totalPrice.text = String(tempTotal + tempTotal / 10 + 2.0) + " $"
        }
    }
    @objc func tapOnPlus(tapGesture:UITapGestureRecognizer) {
        let indexPath = NSIndexPath(row: tapGesture.view!.tag, section: 0)
        guard let cell = cartProduct.cellForRow(at: indexPath as IndexPath) as? CartTableViewCell else { return }
        var tempQuantity = 0
        tempQuantity = Int(cell.quantityProduct.text ?? "0") ?? 0
        tempQuantity = (tempQuantity) + 1
        if tempQuantity > 0 {
            cell.quantityProduct.text = String(tempQuantity)
            let tempTotal = Double(tempQuantity) * priceItem
            self.itemsPriceNumber = tempTotal
            cell.total.text = String(tempTotal) + " $"
            itemsPrice.text = String(tempTotal) + " $"
            taxPrice.text = String(tempTotal / 10) + " $"
            totalPrice.text = String(tempTotal + tempTotal / 10 + 2.0) + " $"
        }
    }
}

extension OrderNowViewController {
    private func createOrder() {
        viewAnimateBuy.isHidden = true
        let taxPriceNumber = self.itemsPriceNumber / 10
        let totalPriceNumber = taxPriceNumber + itemsPriceNumber + 2.0
        APIService.createOrder(2.0,  self.itemsPriceNumber, taxPriceNumber,  totalPriceNumber, itemBuyProduct(), address, city, country, phoneNo, postalCode, UserService.shared.getUserID()) { detailOrder, error in
            self.viewAnimateBuy.isHidden = false
            guard let status = detailOrder?.success else { return }
            if status == true {
                let alert = UIAlertController(title: "Success", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
              
            }
            print("detaiOrder: \(detailOrder)")
        }
    }
}
