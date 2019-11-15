//
//  ConnectTableViewController.swift
//  nRF Toolbox
//
//  Created by Nick Kibysh on 30/08/2019.
//  Copyright © 2019 Nordic Semiconductor. All rights reserved.
//

import UIKit
import CoreBluetooth

class ConnectTableViewController: UITableViewController {
    let connectDelegate: PeripheralConnectionDelegate
    private var peripherals: [DiscoveredPeripheral] = []
    
    init(connectDelegate: PeripheralConnectionDelegate) {
        self.connectDelegate = connectDelegate
        if #available(iOS 13.0, *) {
            super.init(style: .insetGrouped)
        } else {
            super.init(style: .grouped)
        }
    }
    
    required init?(coder: NSCoder) {
        Log(category: .ui, type: .fault).fault("init(coder:) has not been implemented for ConnectTableViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        navigationItem.title = "Connect"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.close))
    }
    
    @objc private func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Devices"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        peripherals.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        let peripheral = peripherals[indexPath.row]
        cell?.textLabel?.text = peripheral.name
        cell?.imageView?.image = UIImage(rssi: peripheral.rssi)
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.connectDelegate.connect(peripheral: self.peripherals[indexPath.row])
    }
    
}

extension ConnectTableViewController: PeripheralListDelegate {
    func peripheralsFound(_ peripherals: [DiscoveredPeripheral]) {
        self.peripherals = peripherals
        tableView.reloadData()
    }
}
