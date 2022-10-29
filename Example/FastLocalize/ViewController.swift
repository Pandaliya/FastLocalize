//
//  ViewController.swift
//  FastLocalize
//
//  Created by zhangpan on 07/26/2022.
//  Copyright (c) 2022 zhangpan. All rights reserved.
//

import UIKit
import FastLocalize

class ViewController: UITableViewController {
    let languages: [String] = [
        "English",
        "简体中文",
        "日本语",
        "한국어"
    ]
    
    let locals: [String] = [
        "English",
        "Chinese",
        "Japanese",
        "Korean"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Language".fastLocalized
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ViewController")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewController", for: indexPath)
        if #available(iOS 14.0, *) {
            var ccf = cell.defaultContentConfiguration()
            ccf.text = self.languages[indexPath.row]
            ccf.secondaryText = self.locals[indexPath.row].fastLocalized
            cell.contentConfiguration = ccf
        } else {
            cell.textLabel?.text = self.languages[indexPath.row]
            cell.detailTextLabel?.text = self.locals[indexPath.row].fastLocalized
        }
        return cell
    }

}

