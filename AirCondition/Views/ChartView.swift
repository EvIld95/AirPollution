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
    init(dates: [Date], last24h: Bool = false) {
        self.dates = dates
        super.init()
        dateFormatter.dateFormat = last24h ? "HH:mm" : "dd-MM-YYYY"
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        guard dates.count > 0 && Int(value) < dates.count else { return " " }
        
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
    var daysAgo = 7
    var data: [Date: Double] = [:] {
        didSet {
            lineDataEntry.removeAll()
            dates.removeAll()
            let now = Date()
            if daysAgo != 1 {
                for i in 0...daysAgo {
                    let components = Calendar.current.dateComponents([.year, .month, .day], from: now)
                    dates.append(Calendar.current.date(byAdding: .day, value: -1*i, to: Calendar.current.date(from: components)!)!)
                }
            } else {
                for i in 0...24 {
                    let components = Calendar.current.dateComponents([.year, .month, .day, .hour], from: now)
                    dates.append(Calendar.current.date(byAdding: .hour, value: -1*i, to: Calendar.current.date(from: components)!)!)
                }
            }
            
            //let keys = data.keys
            let sortedDates = dates.sorted { (el1, el2) -> Bool in
                el1.compare(el2) == .orderedAscending
            }
            
            for (i, date) in sortedDates.enumerated() {
                let value = data[date] ?? 0.0
               // dates.append(date)
                let dataPoint = ChartDataEntry(x: Double(i), y: value)
                lineDataEntry.append(dataPoint)
            }
            
            chartDataSet.values = lineDataEntry
            chartDataSet.notifyDataSetChanged()
            chartData.addDataSet(chartDataSet)
            chartData.notifyDataChanged()
            lineChartView.data = chartData
            lineChartView.notifyDataSetChanged()
            lineChartView.invalidateIntrinsicContentSize()
            lineChartView.xAxis.valueFormatter = DateAxisValueFormatter(dates: sortedDates, last24h: daysAgo == 1)
            lineChartView.xAxis.granularity = 0.2//Double(sortedDates.count) / 5.0
            lineChartView.xAxis.labelRotationAngle = -45
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
        
        
        self.addSubview(lineChartView)
        lineChartView.anchor(top: titleLabel.bottomAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
