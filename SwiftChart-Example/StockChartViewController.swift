//
//  StockChartViewController.swift
//  SwiftChart-Example
//
//  Created by Peter Salz on 18.08.19.
//  Copyright © 2019 Peter Salz App Development. All rights reserved.
//

import UIKit
import PSSwiftChart

class StockChartViewController: UIViewController
{
    @IBOutlet weak var chart: Chart!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var labelLeadingMarginConstraint: NSLayoutConstraint!
    
    var selectedChart = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension StockChartViewController: ChartDelegate {
    
    
}
