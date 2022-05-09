//
//  ListOrderViewController.swift
//  THUONGMAIDIENTU
//
//  Created by Sang Hi Bùi on 15/04/2022.
//

import UIKit
import SDWebImage

class ListOrderViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var listOrderTableView:  UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    //MARK: - Properties
    
    var listOrder: [Order] = []
    var processingOrder: [Order] = []
    var confirmedOrder: [Order] = []
    var deliveredOrder: [Order] = []
    var completeOrder: [Order] = []
    var cancelOrder: [Order] = []
    
    //Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getListOrder()
        listOrderTableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()   
    }
    
    //MARK: - Setups
    
    func formatDate(date: String) -> String {
       let dateFormatterGet = DateFormatter()
       dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
   
       let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd-MM-yyyy HH:mm"

       let dateAfter: Date? = dateFormatterGet.date(from: date)

       return dateFormatterPrint.string(from: dateAfter!)
    }
    
    private func setupTableView() {
        listOrderTableView.dataSource = self
        listOrderTableView.delegate = self
        listOrderTableView.register(UINib(nibName: "ListOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "ListOrderTableViewCell")
        listOrderTableView.tableFooterView = UIView()
    }
    
    //MARK: - Actions
    @IBAction func switchStatus(_ sender: UISegmentedControl) {
        if segmentedControl.selectedSegmentIndex == 0 {
            getListOrder()
            listOrder.removeAll()
         //   listOrder = processingOrder.reversed()
            listOrderTableView.reloadData()
        } else if segmentedControl.selectedSegmentIndex == 1 {
            getListOrder()
            listOrder.removeAll()
            listOrder = confirmedOrder.reversed()
            listOrderTableView.reloadData()
        } else if segmentedControl.selectedSegmentIndex == 2 {
            getListOrder()
            listOrder.removeAll()
            listOrder = deliveredOrder.reversed()
            listOrderTableView.reloadData()
        } else if segmentedControl.selectedSegmentIndex == 3 {
            getListOrder()
            listOrder.removeAll()
            listOrder = completeOrder.reversed()
            listOrderTableView.reloadData()
        } else {
            getListOrder()
            listOrder.removeAll()
            listOrder = cancelOrder.reversed()
            listOrderTableView.reloadData()
        }
    }
}

extension ListOrderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let order = listOrder[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListOrderTableViewCell", for: indexPath) as! ListOrderTableViewCell
        cell.idLabel.text = "Id Order  " + (order._id ?? "")
        if let status = order.orderStatus {
            cell.statusLabel.text = status
        }
        
        cell.imageProduct.sd_setImage(with: URL(string: order.orderItems?.first?.image ?? ""), placeholderImage: UIImage(named: "imageNull"))
        cell.imageProduct.image?.imageResized(to: CGSize(width: 80, height: 80))
        cell.imageProduct.contentMode = .scaleToFill
        cell.nameLabel.text = order.orderItems?.first?.name
        if let quantity = order.orderItems?.first?.quantity {
            cell.quantityLabel.text = "x " + String(quantity)
        }
        
        if let price = order.orderItems?.first?.price {
            cell.priceLabel.text = "Price: " + String(price) + " $"
        }
        if let count = order.orderItems?.count {
            cell.countProductLabel.text = String(count) + " Product"
            if count <= 1 {
                cell.seemoreLabel.isHidden = true
            }
        }
        if let totalPrice = order.totalPrice {
            cell.totalPriceLabel.text = "Total Price: " + String(totalPrice) + " $"
        }
        if let time = order.createAt {
            cell.timeOrder.text = formatDate(date: time)
        }

        cell.selectionStyle = .none
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 235
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let order = listOrder[indexPath.row]
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let detailOrderVC = sb.instantiateViewController(withIdentifier: "DetailOrderViewController") as! DetailOrderViewController
        detailOrderVC.orderID = order._id ?? ""
        self.navigationController?.pushViewController(detailOrderVC, animated: true)
    }
    
}

extension ListOrderViewController {
    
    private func getListOrder() {
        APIService.getListOrder { listOrder, error in
            guard let listOrder = listOrder, let orders = listOrder.orders else { return }
            DispatchQueue.main.async {
                self.processingOrder.removeAll()
                self.confirmedOrder.removeAll()
                self.completeOrder.removeAll()
                self.deliveredOrder.removeAll()
                self.cancelOrder.removeAll()
                for i in 0..<orders.count {
                    if orders[i].orderStatus == "Processing" {
                        self.processingOrder.append(orders[i])
                    } else if orders[i].orderStatus == "Confirmed" {
                        self.confirmedOrder.append(orders[i])
                    } else if orders[i].orderStatus == "Delivered" {
                        self.deliveredOrder.append(orders[i])
                    } else if orders[i].orderStatus == "Complete" {
                        self.completeOrder.append(orders[i])
                    } else  {
                        self.cancelOrder.append(orders[i])
                    }
                }
                if self.segmentedControl.selectedSegmentIndex == 0 {
                    self.listOrder = self.processingOrder.reversed()
                }
                self.listOrderTableView.reloadData()
            }
        }
    }
}
