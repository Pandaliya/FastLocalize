//
//  ViewController.swift
//  FastLocalize
//
//  Created by zhangpan on 07/26/2022.
//  Copyright (c) 2022 zhangpan. All rights reserved.
//

import UIKit
import FastLocalize

let WordLanguages = FastLanguage.allCases

class ViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Language".fastLocalized
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ViewController")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0  {
            return WordLanguages.count
        }
        return SupportsWords.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Supported languages".fastLocalized : "Supported words".fastLocalized
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "ViewController_1") ?? UITableViewCell.init(
                    style: .subtitle,
                    reuseIdentifier: "ViewController_1"
                )
            
            if indexPath.row < WordLanguages.count {
                let lang = WordLanguages[indexPath.row]
                cell.textLabel?.text = lang.title
                cell.detailTextLabel?.text = lang.localizedTitle
                cell.accessoryType = (lang == FastLocalizeManager.shared.language) ? .checkmark : .none
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ViewController", for: indexPath)
            cell.textLabel?.text = SupportsWords[indexPath.row].fastLocalized
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            let vc = WordsTableController.init(word: SupportsWords[indexPath.row])
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.section == 0, indexPath.row < WordLanguages.count{
            FastLocalizeManager.shared.switchLanguage(WordLanguages[indexPath.row], sync: true)
            self.tableView.reloadData()
            self.navigationItem.title = "Language".fastLocalized
        }
    }

}

