//
//  TableViewController.swift
//  SwiftChart-Example
//
//  Created by Peter Salz on 18.08.19.
//  Copyright © 2019 Peter Salz App Development. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 4 {
            performSegue(withIdentifier: "StockChartSegue", sender: nil)
        } else {
            performSegue(withIdentifier: "BasicChartSegue", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "BasicChartSegue" {
            
            let indexPath = tableView.indexPathForSelectedRow
            let dvc = segue.destination as! BasicChartViewController
            dvc.selectedChart = indexPath!.row
        }
    }
}
