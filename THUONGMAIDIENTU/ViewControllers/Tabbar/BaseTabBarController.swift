//
//  BaseTabBarController.swift
//  THUONGMAIDIENTU
//
//  Created by Sang Hi Bùi on 04/03/2022.
//

import UIKit

class BaseTabBarController: UITabBarController, UITabBarControllerDelegate {

    var customTabBar: CustomTabBar!
    var tabBarHeight: CGFloat = 70.0
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadTabBar()
    }

    func loadTabBar() {
        let tabbarItems: [TabItem] = [.home, .favorite, .profile]
        setupCustomTabMenu(tabbarItems)
        
        selectedIndex = 0
    }

    func setupCustomTabMenu(_ menuItems: [TabItem]) {
        
        let frame = tabBar.frame

        // Ẩn tab bar mặc định của hệ thống đi
        tabBar.isHidden = true
        // Khởi tạo custom tab bar
        customTabBar = CustomTabBar(menuItems: menuItems, frame: frame)
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        customTabBar.clipsToBounds = true
        customTabBar.itemTapped = changeTab(tab:)
        
        view.addSubview(customTabBar)

        // Auto layout cho custom tab bar
        NSLayoutConstraint.activate([
            customTabBar.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            customTabBar.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
            customTabBar.widthAnchor.constraint(equalToConstant: tabBar.frame.width),
            customTabBar.heightAnchor.constraint(equalToConstant: tabBarHeight),
            customTabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor , constant: 35)
        ])
        view.layoutIfNeeded()
    }

    func changeTab(tab: Int) {
        self.selectedIndex = tab
    }
}


