//
//  StockChartViewController.swift
//  SwiftChart-Example
//
//  Created by Peter Salz on 18.08.19.
//  Copyright © 2019 Peter Salz App Development. All rights reserved.
//

import UIKit
import PSSwiftChart

class StockChartViewController: UIViewController {
    @IBOutlet weak var chart: Chart!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var labelLeadingMarginConstraint: NSLayoutConstraint!
    
    var selectedChart = 0
    
    fileprivate var labelLeadingMarginInitialConstant: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        labelLeadingMarginInitialConstant = labelLeadingMarginConstraint.constant
        
        initializeChart()
    }
    
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        
        // Redraw chart on rotation.
        chart.setNeedsDisplay()
    }
    
    // MARK: - Helpers
    
    func initializeChart() {
        
        chart.delegate = self
        
        // Initialize data series and labels.
        let stockValues = getStockValues()
        
        var seriesData: [Double] = []
        var labels: [Double] = []
        var labelsAsString: [String] = []
        
        // Date formatter to retrieve month names.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        
        for (i, value) in stockValues.enumerated() {
            
            seriesData.append(value["close"] as! Double)
            
            // Use only one label for each month.
            let month = Int(dateFormatter.string(from: value["date"] as! Date))!
            let monthAsString: String = dateFormatter.monthSymbols[month - 1]
            
            if labels.count == 0 || labelsAsString.last != monthAsString {
                
                labels.append(Double(i))
                labelsAsString.append(monthAsString)
            }
        }
        
        let series = ChartSeries(seriesData)
        series.area = true
        
        // Configure chart layout.
        
        chart.lineWidth = 0.5
        chart.labelFont = UIFont.systemFont(ofSize: 12)
        chart.xLabels = labels
        chart.xLabelsFormatter = { (labelIndex: Int, labelValue: Double) -> String in
            return labelsAsString[labelIndex]
        }
        chart.xLabelsTextAlignment = .center
        chart.yLabelsOnRightSide = true
        // Add some padding above the x-axis.
        chart.minY = seriesData.min()! - 5
        
        chart.add(series)
    }
    
    func getStockValues() -> [[String: Any]] {
        
        // Read JSON file.
        let filePath = Bundle.main.path(forResource: "AAPL", ofType: "json")!
        let jsonData = try? Data(contentsOf: URL(fileURLWithPath: filePath))
        let json: NSDictionary = (try! JSONSerialization.jsonObject(with: jsonData!,
                                                                    options: [])) as! NSDictionary
        let jsonValues = json["quotes"] as! Array<NSDictionary>
        
        // Parse data.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let values = jsonValues.map { (value: NSDictionary) -> [String: Any] in
            
            let date = dateFormatter.date(from: value["date"]! as! String)
            let close = (value["close"]! as! NSNumber).doubleValue
            
            return ["date": date!, "close": close]
        }
        
        return values
    }

}

// MARK: - ChartDelegate

extension StockChartViewController: ChartDelegate {
    
    func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat) {
        
        if let value = chart.value(forSeries: 0, at: indexes[0]) {
            
            let numberFormatter = NumberFormatter()
            numberFormatter.minimumFractionDigits = 2
            numberFormatter.maximumFractionDigits = 2
            label.text = numberFormatter.string(from: NSNumber(value: value))
            
            // Align the label to the touch left position, centered.
            var constant = labelLeadingMarginInitialConstant + left - label.frame.width / 2
            
            // Avoid placing the label on the left of the chart.
            if constant < labelLeadingMarginInitialConstant {
                constant = labelLeadingMarginInitialConstant
            }
            
            // Avoid placing the label on the right of the chart.
            let rightMargin = chart.frame.width - label.frame.width
            
            if constant > rightMargin {
                constant = rightMargin
            }
            
            labelLeadingMarginConstraint.constant = constant
        }
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
        
        label.text = ""
        labelLeadingMarginConstraint.constant = labelLeadingMarginInitialConstant
    }
    
    func didEndTouchingChart(_ chart: Chart) { }
    
}
