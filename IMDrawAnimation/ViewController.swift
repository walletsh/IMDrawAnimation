//
//  ViewController.swift
//  IMDrawAnimation
//
//  Created by imwallet on 16/12/13.
//  Copyright © 2016年 imWallet. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dataArray = Array<String>()
    var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        title = "动画事例"
        
        setupData()
        
        setupUI()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController{
    
    fileprivate func setupData() {
        dataArray.append("MusicBar")
        dataArray.append("WaterPulse")
        dataArray.append("CellAnimation")
    }
    
    fileprivate func setupUI() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .singleLine
        view.addSubview(tableView)
    }
}


// MARK: - UITableViewDataSource && UITableViewDelegate
extension ViewController{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellID")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cellID")
        }
        cell?.textLabel?.text = dataArray[indexPath.row]
        cell?.accessoryType = .disclosureIndicator
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            self.navigationController?.pushViewController(IMMusicBarViewController(), animated: true)
        case 1:
            self.navigationController?.pushViewController(IMWaterPulseViewController(), animated: true)
        case 2:
            self.navigationController?.pushViewController(IMCellAnimationViewController(), animated: true)
        default: break
            
        }
    }
    
}


