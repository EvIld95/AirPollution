//
//  ChartView.swift
//  AirCondition
//
//  Created by Paweł Szudrowicz on 11/07/2019.
//  Copyright © 2019 Paweł Szudrowicz. All rights reserved.
//

import Foundation
import UIKit
import Charts


class DateAxisValueFormatter : NSObject, IAxisValueFormatter {
    let dateFormatter = DateFormatter()
    let dates: [Date]
    init(dates: [Date]) {
        self.dates = dates
        super.init()
        dateFormatter.dateFormat = "dd-MM HH:mm"
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        guard dates.count > 0 else { return " " }
        let date = dates[Int(value)]
        return dateFormatter.string(from: date)
    }
}

class ChartView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    var lineDataEntry = [ChartDataEntry]()
    var chartDataSet = LineChartDataSet()
    var chartData = LineChartData()
    let lineChartView = LineChartView()
    var dates = [Date]()
    var data: [(Date, Double)] = [] {
        didSet {
            lineDataEntry.removeAll()
            dates.removeAll()
            for (i, (date, snap)) in data.enumerated() {
                dates.append(date)
                let dataPoint = ChartDataEntry(x: Double(i), y: snap)
                lineDataEntry.append(dataPoint)
            }
            chartDataSet.values = lineDataEntry
            chartDataSet.notifyDataSetChanged()
            chartData.addDataSet(chartDataSet)
            lineChartView.data = chartData
            lineChartView.xAxis.valueFormatter = DateAxisValueFormatter(dates: dates)
        }
    }
    
    init(frame: CGRect, title: String) {
        super.init(frame: frame)
        
        
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 10, left: 10, bottom: 0, right: 10), size: .init(width: 0, height: 50))
        titleLabel.text = title
        
  
        //var lineDataEntry = [ChartDataEntry]()
        
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        lineChartView.heightAnchor.constraint(equalToConstant: 200).isActive = true
//        for (i, snap) in data.enumerated() {
//            let dataPoint = ChartDataEntry(x: Double(i), y: snap)
//            lineDataEntry.append(dataPoint)
//        }
    
        
        
        chartDataSet.colors = [UIColor.red]
        chartDataSet.circleColors = [UIColor.gray]
        chartDataSet.circleRadius = 4.0
        
       
        
        let gradientColors = [UIColor.white.cgColor, UIColor.red.cgColor]
        let colorLocations: [CGFloat] = [1.0, 0.0]
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors as CFArray, locations: colorLocations)
        chartDataSet.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0)
        chartDataSet.drawFilledEnabled = true
        chartDataSet.drawCirclesEnabled = false
        chartDataSet.drawValuesEnabled = false
        
//        lineChartView.data = chartData
        lineChartView.drawBordersEnabled = false
        //lineChartView.xAxis.drawLabelsEnabled = false
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.leftAxis.drawGridLinesEnabled = false
        lineChartView.leftAxis.drawLabelsEnabled = false
        lineChartView.legend.enabled = false
        lineChartView.rightAxis.drawGridLinesEnabled = false
        lineChartView.isUserInteractionEnabled = false
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.granularity = 10
        
        self.addSubview(lineChartView)
        lineChartView.anchor(top: titleLabel.bottomAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
