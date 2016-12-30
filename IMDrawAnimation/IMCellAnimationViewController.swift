//
//  IMCellAnimationViewController.swift
//  IMDrawAnimation
//
//  Created by imwallet on 16/12/30.
//  Copyright © 2016年 imWallet. All rights reserved.
//

import UIKit

class IMCellAnimationViewController: UIViewController{
    
    lazy var dataArray: [String] = {
        var datas = [String]()
        for idx in 0...25{
            datas.append("商品\(idx)号")
        }
        return datas
    }()

    fileprivate lazy var tableView: UITableView = {
        let table: UITableView = UITableView(frame: self.view.bounds, style: .plain)
        table.backgroundColor = UIColor.clear
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        table.separatorStyle = .singleLine
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        view.addSubview(tableView)
        
//        if tableView.responds(to: #selector(getter: tableView.separatorInset)) {
//            tableView.separatorInset = UIEdgeInsets.zero
//        } else {
//            tableView.separatorInset = UIEdgeInsets.zero
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cellStartAnimation()
    }
}

// MARK: - UITableViewDataSource && UITableViewDelegate
extension IMCellAnimationViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellID")
        if cell == nil {
            cell = IMAnimationCell(style: .default, reuseIdentifier: "cellID")
        }
        cell?.accessoryType = .disclosureIndicator
        cell?.textLabel?.text = dataArray[indexPath.row]
        cell?.textLabel?.textColor = UIColor.white
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        setupCellSeparatorInset(cell, indexPath)
        cell.backgroundColor = cellColorForRow(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "删除") { (action, indexPath) in
            print("deleteAction row \(indexPath.row) have taped")
        }
        deleteAction.backgroundColor = UIColor.randomColor()
//        deleteAction.backgroundEffect = UIBlurEffect(style: .light)
        
        let shareAction = UITableViewRowAction(style: .default, title: "分享") { (action, indexPath) in
            print("shareAction row \(indexPath.row) have taped")
        }
        shareAction.backgroundColor = UIColor.randomColor()
//        shareAction.backgroundEffect = UIBlurEffect(style: .light)

        let moreAction = UITableViewRowAction(style: .default, title: "更多") { (action, indexPath) in
            print("moreAction row \(indexPath.row) have taped")
        }
        moreAction.backgroundColor = UIColor.randomColor()
//        moreAction.backgroundEffect = UIBlurEffect(style: .dark)

        return [deleteAction, shareAction, moreAction]
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
}

extension IMCellAnimationViewController{
    
    fileprivate func setupCellSeparatorInset(_ cell: UITableViewCell, _ indexPath: IndexPath) {
        
        let inset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        
        if cell.responds(to: #selector(getter: tableView.separatorInset)) {
            if indexPath.row == dataArray.count - 1 {
                cell.separatorInset = UIEdgeInsets.zero
            } else {
                cell.separatorInset = inset
            }
        } else {
            cell.separatorInset = UIEdgeInsets.zero
        }
    }
    
    fileprivate func cellStartAnimation() {
        
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        
        for (index, cell) in cells.enumerated() {
            cell.transform = CGAffineTransform(translationX: 0, y: tableView.frame.size.height)
            
            UIView.animate(withDuration: 1.0, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }
    
    fileprivate func cellColorForRow(_ row: Int) -> UIColor {
        
        let itemCount = dataArray.count - 1
        let color = (CGFloat(row) / CGFloat(itemCount)) * 0.8
        return UIColor(red: 0.8, green: color, blue: 1.0, alpha: 1.0)
    }
}

