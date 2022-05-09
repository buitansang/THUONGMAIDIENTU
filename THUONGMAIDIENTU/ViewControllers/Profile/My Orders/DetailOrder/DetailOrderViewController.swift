//
//  DetailOrderViewController.swift
//  THUONGMAIDIENTU
//
//  Created by Sang Hi Bùi on 15/04/2022.
//

import UIKit
import NVActivityIndicatorView

class DetailOrderViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var itemOrderTableView: UITableView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var cancelOrder: UIButton!
    @IBOutlet weak var receivedOrder: UIButton!

    //MARK: - Properties
    
    var orderID: String = ""
    var itemsOrder: [OrderItem] = []
    let loading = NVActivityIndicatorView(frame: .zero, type: .lineSpinFadeLoader, color: .black, padding: 0)
    let totalPriceLabel = UILabel(frame: CGRect(x: 15, y: 90, width: 315, height: 30))
    let taxPrice = UILabel(frame: CGRect(x: 15, y: 60, width: 315, height: 30))
    let itemsPrice = UILabel(frame: CGRect(x: 15, y: 30, width: 315, height: 30))
    let shippingPrice = UILabel(frame: CGRect(x: 15, y: 0, width: 315, height: 30))
    let cancelString = "Cancel"
    let completeString = "Complete"
    var status = ""
    
    //MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad() 
        setupAnimation()
        setupItemOrderTableView()
        getDetailOrder()
   
    }
    //MARK: - Setups
    
    private func setupAnimation() {
        loading.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loading)
        NSLayoutConstraint.activate([
            loading.widthAnchor.constraint(equalToConstant: 25),
            loading.heightAnchor.constraint(equalToConstant: 25),
            loading.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loading.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100)
        ])
    }
    
    private func setupButton() {
        cancelOrder.isHidden = true
        cancelOrder.layer.cornerRadius = 15
        receivedOrder.isHidden = true
        receivedOrder.layer.cornerRadius = 15
    }
    
    private func setupItemOrderTableView() {
        itemOrderTableView.dataSource = self
        itemOrderTableView.dataSource = self
        itemOrderTableView.register(UINib(nibName: "DetailOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailOrderTableViewCell")
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 130))
        totalPriceLabel.textColor = .systemRed
        taxPrice.textColor = .black
        itemsPrice.textColor = .black
        shippingPrice.textColor = .black
        customView.backgroundColor = UIColor.white
        customView.addSubview(taxPrice)
        customView.addSubview(totalPriceLabel)
        customView.addSubview(itemsPrice)
        customView.addSubview(shippingPrice)
        itemOrderTableView.tableFooterView = customView
    }
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapCancel(_ sender: UIButton) {
        self.status = cancelString
        let alert = UIAlertController(title: "You want to cancel order", message: "You sure?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cencal", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.updateOrderStatus(with: self.status)
            self.navigationController?.popViewController(animated: true)
        }))
        print("didTapCancel")
        self.present(alert, animated: true)        
    }
    
    @IBAction func didTapReceived(_ sender: UIButton) {
        print("didTapReceived")
        status = completeString
        updateOrderStatus(with: status)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapWriteReview(_ sender: UIButton) {
        print(itemsOrder)
       
        let indexPath = IndexPath(row: sender.tag, section: 0)
        print(indexPath.row)
        let product = itemsOrder[indexPath.row]
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let reviewVC = sb.instantiateViewController(identifier: "ReviewViewController") as! ReviewViewController
        reviewVC.name = product.name ?? ""
        reviewVC.imageURL = product.image ?? ""
        reviewVC.productID = product.product ?? ""
      //  self.navigationController?.pushViewController(reviewVC, animated: true)
        self.navigationController?.present(reviewVC, animated: true, completion: nil)
    }
}

extension DetailOrderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemsOrder[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailOrderTableViewCell", for: indexPath) as! DetailOrderTableViewCell
        cell.imageProduct.sd_setImage(with: URL(string: item.image ?? ""), placeholderImage: UIImage(named: "imageNull"))
        cell.imageProduct.image?.imageResized(to: CGSize(width: 80, height: 80))
        cell.imageProduct.contentMode = .scaleToFill
        cell.nameLabel.text = item.name
        if let quantity = item.quantity {
            cell.quantityLabel.text = "x " + String(quantity)
        }
        if let price = item.price {
            cell.priceLabel.text = "Price: " + String(price) + " $"
        }
        
        if status == "Complete" {
            cell.ratingOrder.isHidden = false
        } else {
            cell.ratingOrder.isHidden = true
        }
        cell.ratingOrder.tag = indexPath.row
        cell.ratingOrder.addTarget(self, action: #selector(didTapWriteReview(_:)), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 130
    }
}

extension DetailOrderViewController {
    
    private func getDetailOrder() {
        loading.startAnimating()
        APIService.getDetailOrder(with: orderID ?? "") { detailOrder, error in
            self.loading.stopAnimating()
            guard let detailOrder = detailOrder else { return }
            DispatchQueue.main.async {
                
                // Shipping Info
                let space = "     "
                self.shippingPrice.text = "Shipping Price:                 2 $"
                guard let address = detailOrder.order?.shippingInfo?.address else { return }
                self.addressLabel.text = "Address: " + space + address
                guard let city = detailOrder.order?.shippingInfo?.city else { return }
                self.cityLabel.text = "City:       " + space + city
                guard let country = detailOrder.order?.shippingInfo?.country else { return }
                self.countryLabel.text = "Country: " + space + country
                guard let phone = detailOrder.order?.shippingInfo?.phoneNo else { return }
                self.phoneLabel.text = "Phone:   " + space + phone
                
                //List order
                guard let itemsOrder = detailOrder.order?.orderItems else { return }
                self.itemsOrder = itemsOrder
                
                // Footer
                let space1 = "                "
                guard let totalPrice = detailOrder.order?.totalPrice else { return }
                self.totalPriceLabel.text = "Total Price:       " + space1 + String(totalPrice) + " $"
                guard let taxPrice = detailOrder.order?.taxPrice else { return }
                self.taxPrice.text = "Tax Price:          " + space1 + String(taxPrice) + " $"
                guard let itemsPrice = detailOrder.order?.itemsPrice else { return }
                self.itemsPrice.text = "Items Price:       " + space1 + String(itemsPrice) + " $"
                
                //Button
                guard let status = detailOrder.order?.orderStatus else { return }
                
                self.status = status
                
                if status == "Processing" {
                    self.cancelOrder.isHidden = false
                }
                if status == "Delivered" {
                    
                    self.receivedOrder.isHidden = false
                }
                self.itemOrderTableView.reloadData()
                print("DetailOrder: \(detailOrder)")
            }
        }
    }
    
    // update status order
    private func updateOrderStatus(with status: String) {
        APIService.updateOrderStatus(with: orderID, status) { detailOrder, error in
            guard let detailOrder = detailOrder else { return }
            print("updateStatus: \(detailOrder)")
        }
    }
}
