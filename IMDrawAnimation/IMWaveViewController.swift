//
//  IMWaveViewController.swift
//  IMDrawAnimation
//
//  Created by imwallet on 17/1/4.
//  Copyright © 2017年 imWallet. All rights reserved.
//

import UIKit

class IMWaveViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension IMWaveViewController: UITableViewDelegate, UITableViewDataSource{
    
    fileprivate func setupUI() {
        let waveView = IMWaveProgressView(frame: CGRect(x: 0, y: 0, width: screenW, height: screenH * 0.3))
        waveView.maskWaveColor = UIColor.orange.withAlphaComponent(0.5)
        waveView.realWaveColor = UIColor.red
        waveView.backgroundColor = UIColor.lightGray
        
        let tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = waveView
        view.addSubview(tableView)
        
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellID")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cellID")
        }
        cell?.accessoryType = .disclosureIndicator
        cell?.textLabel?.text = "HOHO" + String(indexPath.row)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
