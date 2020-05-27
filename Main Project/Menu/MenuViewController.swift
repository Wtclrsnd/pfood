//
//  HomeViewController.swift
//  Main Project
//
//  Created by Тимур Бакланов on 04.03.2020.
//  Copyright © 2020 Тимур Бакланов. All rights reserved.
//

import UIKit
import Firebase

private let reusableIdentifier = "myCell"

class MenuViewController: UIViewController {
    
    var ref: DatabaseReference = Database.database().reference()
    var modelArray: [MenuModel] = []
    //MARK: - Properties
    weak  var barDelegate: MenuControllerDelegate?
    
    lazy var collectiomView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let width = UIScreen.main.bounds.width
        layout.sectionInset = UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20)
        layout.itemSize = CGSize(width: (width - 60) / 2, height: width / 2)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 50
        
        let collectiomView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectiomView.delegate = self
        collectiomView.dataSource = self
        collectiomView.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: reusableIdentifier)
        return collectiomView
    }()
    
    //MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        let categories = ref.child("categories")
        categories.observe(.value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let name = child.key as String
                var imageURL = ""
                
                let categories = categories.child(name)
                categories.observe(.value) { (snapshot) in
                    let firstInCategory = snapshot.children.first { _ in return true } as! DataSnapshot
                    imageURL = (firstInCategory.value as? NSDictionary)?["imageUrl"] as? String ?? ""
                    let menuModel = MenuModel(name: name, imageURL: imageURL)
                    self.modelArray.append(menuModel)
                    self.collectiomView.reloadData()
                }
            }
        }
        view.backgroundColor = .white
        configureNaivationBar()
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let navBar = navigationController?.navigationBar as? MainNavigationBar
        navBar?.leftButton.isHidden = false
    }
    
    //MARK: - Configure UI
    
    func configureCollectionView() {
        view.addSubview(collectiomView)
        collectiomView.translatesAutoresizingMaskIntoConstraints = false
        collectiomView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectiomView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectiomView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectiomView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectiomView.backgroundColor = .white
    }
    
    func configureNaivationBar() {
        navigationController?.navigationBar.barTintColor = .orange
        navigationController?.navigationBar.barStyle = .black
        
        let leftButton = UIButton(type: .system)
        leftButton.setImage(UIImage(named: "lines"), for: .normal)
        leftButton.addTarget(self, action: #selector(openHamburgerAction), for: .touchUpInside)
        leftButton.tintColor = .white

        let rightButton = UIButton(type: .system)
        rightButton.setImage(UIImage(named: "Cart"), for: .normal)
        rightButton.addTarget(self, action: #selector(openShoppingCardAction), for: .touchUpInside)
        rightButton.tintColor = .white

        let titleView = UILabel(frame: .zero)
        titleView.text = "Меню"
        titleView.font = .boldSystemFont(ofSize: 20)
        titleView.textColor = .white
        titleView.textAlignment = .left

        let navBar = navigationController?.navigationBar as? MainNavigationBar
        navBar?.setLeftButton(leftButton)
        navBar?.setRightButton(rightButton)
        navBar?.setCenterView(titleView)
        
        navBar?.sumLabel.text = String(ShoppingCart.shared.getSum())
    }

    
    //MARK: - Handlers
    
    @objc func openHamburgerAction() {
        barDelegate?.hamburgerButtonDidTap()
    }
    
    @objc func openShoppingCardAction() {
        if let rootVC = UIApplication.shared.windows.first?.rootViewController as? ViewController {
            rootVC.hamburgerMenuController.delegate?.handleMenuToggle(forMenuOption: MenuOptionModel.ShoppingCard)
        }
    }
}


//MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension MenuViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelArray.count
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableIdentifier, for: indexPath) as! MenuCollectionViewCell
        cell.itemButton.setTitle(String(modelArray[indexPath.row].name), for: .normal)
        cell.itemImageView.load(mainModel: modelArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MenuCollectionViewCell
        let nexMenuVC = NextMenuViewController()
        nexMenuVC.titleText = cell.itemButton.titleLabel?.text
        self.navigationController?.pushViewController(nexMenuVC, animated: true)
    }
}


extension UIImageView {
    func load(mainModel: MenuModel) {
        if let image = mainModel.image { self.image = image; return }
        
        let urlText = mainModel.imageURL
        guard let url = URL(string: urlText.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!) else { return }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                guard let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    mainModel.image = image
                    self?.image = mainModel.image
                }
            }
        }
    }
}
