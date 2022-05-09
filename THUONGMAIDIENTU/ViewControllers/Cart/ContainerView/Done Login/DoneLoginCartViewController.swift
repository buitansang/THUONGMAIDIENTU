//
//  doneLoginCartViewController.swift
//  THUONGMAIDIENTU
//
//  Created by Sang Hi Bùi on 19/03/2022.
//

import UIKit
import SDWebImage
import NVActivityIndicatorView
import Alamofire

class DoneLoginCartViewController: UIViewController, UIGestureRecognizerDelegate {

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
    @IBOutlet weak var thongBaoView: UIView!
    
    //MARK: - Properties
    
    var productsInCart: [ProductInCart] = []
    var productId: String = ""
    var ticked = [Int: Bool]()
    var tickedProduct: [ProductInCart?] = []
    var tmpProducts: [ProductInCart] = []
    var buyProducts: [ProductInCart] = []
    var itemsPriceNumber: Double = 0.0
    var taxPriceNumber: Double = 0.0
    var totalPriceNumber: Double = 0.0
    let shippingPrice: Double = 2.0
    
    var address = ""
    var city = ""
    var country = ""
    var phoneNo = ""
    var postalCode = ""
    
    let loading = NVActivityIndicatorView(frame: .zero, type: .lineSpinFadeLoader, color: .black, padding: 0)
    private let viewAnimate: UIView = {
        let view = UIView()
        view.frame = .zero
        view.backgroundColor = .white
        return view
    }()
    
    let loadingBuy = NVActivityIndicatorView(frame: .zero, type: .lineSpinFadeLoader, color: .white, padding: 0)
    private let viewAnimateBuy: UIView = {
        let view = UIView()
        view.frame = .zero
        view.backgroundColor = .lightGray
        return view
    }()
    
    //MARK: - LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bankData()
        self.navigationItem.leftBarButtonItems = []
        self.navigationItem.hidesBackButton = true
        NotificationCenter.default.addObserver(self, selector: #selector(logout), name: Notification.Name("logout"), object: nil)
        if UserService.shared.getToken() != "" {
            getMyCart()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.thongBaoView.isHidden = true
        view.addSubview(viewAnimate)
        NotificationCenter.default.addObserver(self, selector: #selector(self.getShippingInfo(_:)), name: NSNotification.Name(rawValue: "shippingInfo"), object: nil)
        setupViewAnimate()
        setupAnimation()
        setupTableView()
        setupUI()
        setupShipping()
        tapDoneButton()
        setupKeyboard()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
       // NotificationCenter.default.removeObserver(self)
    }
    //MARK: - Setups
    
    private func setupViewAnimateBuy() {
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
    
    @objc func getShippingInfo(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            guard let address = dict["address"] as? String,
                  let city = dict["city"] as? String,
                  let country = dict["country"] as? String,
                  let phoneNo = dict["phoneNo"] as? String,
                  let postalCode = dict["postalCode"] as? String
            else { return }
            self.address = address
            self.city = city
            self.country = country
            self.phoneNo = phoneNo
            self.postalCode = postalCode
        }
    }
    
    private func getProductTicked() {
        tickedProduct.removeAll()
        for (key, value) in ticked {
            print("key:\(key) value:\(value)")
            if value == true {
                tickedProduct.append(tmpProducts[key])
            }
            else {
                tickedProduct.append(nil)
            }
        }
        print("San pham ticked trong cart la: \(tickedProduct.count)")
        print("tickedProduct: \(tickedProduct)")
    }
    
    private func setupViewAnimate() {
        viewAnimate.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewAnimate)
        NSLayoutConstraint.activate([
            viewAnimate.widthAnchor.constraint(equalTo: view.widthAnchor),
            viewAnimate.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -60),
            viewAnimate.leftAnchor.constraint(equalTo: view.leftAnchor, constant:  0),
            viewAnimate.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
        ])
    }
    
    private func setupAnimation() {
        loading.translatesAutoresizingMaskIntoConstraints = false
        viewAnimate.addSubview(loading)
        NSLayoutConstraint.activate([
            loading.widthAnchor.constraint(equalToConstant: 30),
            loading.heightAnchor.constraint(equalToConstant: 30),
            loading.centerXAnchor.constraint(equalTo: viewAnimate.centerXAnchor),
            loading.centerYAnchor.constraint(equalTo: viewAnimate.centerYAnchor, constant: 25)
        ])
        loading.startAnimating()
    }
    
    private func setupUI() {
        shippingInfoView.layer.borderWidth = 1
        shippingInfoView.layer.cornerRadius = 5
        shippingInfoView.layer.borderColor = UIColor.systemGreen.cgColor
        buyButton.layer.cornerRadius = 12
        
    }
    
    private func bankData() {
        tmpProducts.removeAll()
        tickedProduct.removeAll()
        buyProducts.removeAll()
        itemsPrice.text = "0 $"
        taxPrice.text = "0 $"
        totalPrice.text = "0 $"
    }
    
    private func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupTableView() {
        cartProduct.dataSource = self
        cartProduct.delegate = self
        cartProduct.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "CartTableViewCell")
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

    private func setupShipping() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapShipping))
        shipping.addGestureRecognizer(gesture)
    }
    
    @objc func logout(notification: NSNotification) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset: UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 100
        scrollView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    @objc func didTapOnView() {
        view.endEditing(true)
    }
    
    @objc func didTapShipping() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let editAddressVC = sb.instantiateViewController(withIdentifier: "EditAddressViewController") as! EditAddressViewController
        self.navigationController?.pushViewController(editAddressVC, animated: true)
    }
    
    @IBAction func didTapBuyButton(_ sender: UIButton) {
        
        if (address.count<=0) || (city.count<=0) || (phoneNo.count<=0) || (country.count<=0) || (postalCode.count<=0) {
            let alert = UIAlertController(title: "Shipping info is empty!!!", message: "Please input shipping info.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if buyProducts.count <= 0 {
            let alert = UIAlertController(title: "Empty Product !!!", message: "Please select product you want buy.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            buyButton.isEnabled = false
            print("didTapBuyButton")
            createOrder()
        }
    }
}

extension DoneLoginCartViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsInCart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let productInCart = productsInCart[indexPath.row]
        let tmpProduct = tmpProducts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell
        cell.separatorInset = UIEdgeInsets(top: 0, left: 143, bottom: 0, right: 0)
        cell.nameProduct.text = productInCart.name
        cell.imageProduct.sd_setImage(with: URL(string: productInCart.image ?? ""), placeholderImage: UIImage(named: "sang"))
        cell.imageProduct.contentMode = .scaleToFill
        if let quantity = tmpProduct.quantity {
            cell.quantityProduct.text = String(quantity)
        }
        
        if let price = productInCart.price, let quantity = cell.quantityProduct.text {
            cell.price.text = String(price) + " $"
        }
        if let total = tmpProduct.total {
            cell.total.text = String(total) + " $"
        }
        
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
        
        if  ticked[indexPath.row] == true {
            cell.checkBox.image = UIImage(named: "check")
        } else {
            cell.checkBox.image = UIImage(named: "uncheck")
        }
        
        cell.selectionStyle = .none

        return cell
    }
    
    @objc func tapOnMinus(tapGesture:UITapGestureRecognizer) {
        
        guard let price = productsInCart[tapGesture.view!.tag].price else { return }
        print("Label tag is:\(tapGesture.view!.tag)")
        let indexPath = NSIndexPath(row: tapGesture.view!.tag, section: 0)
        guard let cell = cartProduct.cellForRow(at: indexPath as IndexPath) as? CartTableViewCell else { return }
        var tempQuantity = 0
        tempQuantity = Int(cell.quantityProduct.text ?? "0") ?? 0
        tempQuantity = (tempQuantity) - 1
        if tempQuantity > 0 {
            cell.quantityProduct.text = String(tempQuantity)
            cell.total.text = String(Double(tempQuantity) * price)
            tmpProducts[indexPath.row].quantity = tempQuantity
            tmpProducts[indexPath.row].total = Double(tempQuantity) * price
            if ticked[indexPath.row] == true {
                tickedProduct[indexPath.row]?.quantity = tmpProducts[indexPath.row].quantity
                tickedProduct[indexPath.row]?.total = tmpProducts[indexPath.row].total
                itemsPriceNumber = itemsPriceNumber - price
                taxPriceNumber = itemsPriceNumber / 10
                totalPriceNumber = itemsPriceNumber + taxPriceNumber + shippingPrice
                itemsPrice.text = String(itemsPriceNumber) + " $"
                taxPrice.text = String(taxPriceNumber) + " $"
                totalPrice.text = String(totalPriceNumber) + " $"
                getProductTicked()
                buyProducts = tickedProduct.flatMap{$0}
                print("buyProducts\(buyProducts)")
            }
        }
        print("ticked Product: \(tickedProduct)")
        print("tmp Product: \(tmpProducts)")
    }
    
    @objc func tapOnPlus(tapGesture:UITapGestureRecognizer){
        print("Label tag is:\(tapGesture.view!.tag)")
        let indexPath = NSIndexPath(row: tapGesture.view!.tag, section: 0)
        guard let price = productsInCart[indexPath.row].price else { return }
        guard let cell = cartProduct.cellForRow(at: indexPath as IndexPath) as? CartTableViewCell else { return }
        var tempQuantity = 0
        tempQuantity = Int(cell.quantityProduct.text ?? "0") ?? 0
        tempQuantity = (tempQuantity) + 1
        cell.quantityProduct.text = String(tempQuantity)
        cell.total.text = String(Double(tempQuantity) * price)
        tmpProducts[indexPath.row].quantity = tempQuantity
        tmpProducts[indexPath.row].total = Double(tempQuantity) * price
   
        if ticked[indexPath.row] == true {
            tickedProduct[indexPath.row]?.quantity = tmpProducts[indexPath.row].quantity
            tickedProduct[indexPath.row]?.total = tmpProducts[indexPath.row].total
            itemsPriceNumber = itemsPriceNumber + price
            taxPriceNumber = itemsPriceNumber / 10
            totalPriceNumber = itemsPriceNumber + taxPriceNumber + shippingPrice
            itemsPrice.text = String(itemsPriceNumber) + " $"
            taxPrice.text = String(taxPriceNumber) + " $"
            totalPrice.text = String(totalPriceNumber) + " $"
            getProductTicked()
            buyProducts = tickedProduct.flatMap{$0}
        }
        print("ticked Product: \(tickedProduct)")
        print("tmp Product: \(tmpProducts)")
        print("buyProducts\(buyProducts)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CartTableViewCell else { return }
        
        if ticked[indexPath.row] == true {
            cell.checkBox.image = UIImage(named: "uncheck")
        } else {
            cell.checkBox.image = UIImage(named: "check")
        }
        ticked[indexPath.row] = !(ticked[indexPath.row] ?? false)
        print("tikedProduct\(ticked)")
        getProductTicked()
        
        itemsPriceNumber = 0.0
        taxPriceNumber = 0.0
        // Tính toán để hiện giá lên các label
        for i in 0..<tickedProduct.count {
            if tickedProduct[i] != nil {
                itemsPriceNumber += tickedProduct[i]?.total ?? 0.0
            }
        }
        taxPriceNumber = itemsPriceNumber / 10
        totalPriceNumber = itemsPriceNumber + taxPriceNumber + shippingPrice
        itemsPrice.text = String(itemsPriceNumber) + " $"
        taxPrice.text = String(taxPriceNumber) + " $"
        totalPrice.text = String(totalPriceNumber) + " $"
        
        buyProducts = tickedProduct.flatMap{$0}
        print("BUY PRODUCT: \(buyProducts)")
      //  tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let productInCart = productsInCart[indexPath.row]
        if let productId = productInCart._id {
            self.productId = productId
        }
        let deleteItem = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, boolValue) in
            self.deleteCart()
            self.productsInCart.remove(at: indexPath.row)
            self.bankData()
            self.tmpProducts = self.productsInCart
           // self.tmpProducts.remove(at: indexPath.row)
            print("product ticked: \(self.productsInCart)")
            self.ticked.removeValue(forKey: indexPath.row)
            for i in 0..<self.productsInCart.count {
                self.ticked[i] = false
            }
            
            print("Delete ticked: \(self.ticked)")
            
            if self.productsInCart.isEmpty {
                self.thongBaoView.isHidden = false
                self.scrollView.isHidden = true
            }
            tableView.deleteRows(at: [indexPath], with: .none)
            tableView.reloadData()
        }
        let swipeAction = UISwipeActionsConfiguration(actions: [deleteItem])
        return swipeAction
    }
}

//Call API
extension DoneLoginCartViewController {
    //Call API get product in my Cart
    private func getMyCart() {
        viewAnimate.isHidden = false
        APIService.getMyCart { myCart, error in
            self.viewAnimate.isHidden = true
            guard let myCart = myCart else {
                self.thongBaoView.isHidden = false
                self.scrollView.isHidden = true
                return
            }
            guard let productsInCart = myCart.myCart else { return }
            DispatchQueue.main.async {
                self.thongBaoView.isHidden = true
                self.scrollView.isHidden = false
                self.productsInCart = productsInCart
                self.tmpProducts = productsInCart
                for i in 0..<productsInCart.count {
                    self.ticked[i] = false
                }
                
                self.cartProduct.reloadData()
                print("Products In Cart: \(self.productsInCart)")
                
            }
        }
    }
    
    //Call API delete Product in my Cart
    private func deleteCart() {
        APIService.deleteCart(with: productId) { deleteProduct, error in
            guard let deleteProduct = deleteProduct else { return }
            print("Delete Product: \(deleteProduct.success)")
        }
    }
    // Call API Create Order
    private func createOrder() {
        guard let order = try? JSONEncoder().encode(buyProducts) else { return }
        guard var orderItems = String(data: order, encoding: .utf8) else { return }
        print(convertToDictionary(text: orderItems))
        viewAnimateBuy.isHidden = false
        APIService.createOrder(shippingPrice, itemsPriceNumber, taxPriceNumber, totalPriceNumber, convertToDictionary(text: orderItems), address, city, country, phoneNo, postalCode, UserService.shared.getUserID()) { detailOrder, error in
            self.viewAnimateBuy.isHidden = true
            guard let statusCreateOrder = detailOrder?.success else { return }
            if statusCreateOrder == true {
                self.buyButton.isEnabled = true
                self.getMyCart()
                let alert = UIAlertController(title: "Success", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                print("fail to create Order")
            }
            print("Create Order: \(detailOrder)")
        }
    }
    
    func convertToDictionary(text: String) -> [[String: Any]]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
