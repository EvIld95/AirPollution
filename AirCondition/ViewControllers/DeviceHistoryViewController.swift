//
//  DeviceHistoryViewController.swift
//  AirCondition
//
//  Created by Paweł Szudrowicz on 03/07/2019.
//  Copyright © 2019 Paweł Szudrowicz. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Charts
import RxCocoa

class DeviceHistoryViewController: UIViewController {
    var viewModel: DeviceHistoryViewModel!
    let disposeBag = DisposeBag()
    
    var chartView1: ChartView!
    var chartView2: ChartView!
    var chartView3: ChartView!
    var chartView4: ChartView!
    var chartView5: ChartView!
    var chartView6: ChartView!
    var chartView7: ChartView!
    
    override func viewDidLoad() {
        self.view.setupGradientLayer()
        self.setupLayout()
        self.setupRx()
    }
    
    lazy var scrollView : UIScrollView = {
        let sv = UIScrollView(frame: .init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        sv.isDirectionalLockEnabled = true
        
        return sv
    }()
    
    let timeSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Month", "Week", "24h"])
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    let chartStackView: UIStackView = {
        let sv = UIStackView()
        sv.distribution = .equalSpacing
        sv.alignment = .fill
        sv.axis = .vertical
        sv.spacing = 10
        
        return sv
    }()
    
    func setupRx() {
        self.viewModel.output.filteredSnapshots.asObservable().skip(1).observeOn(MainScheduler.instance).subscribe(onNext: { data in
            self.drawCharts(data: data)
        }).disposed(by: disposeBag)
        
        self.timeSegmentedControl.rx.selectedSegmentIndex.skip(1).asObservable().subscribe(onNext: { value in
            var days = 0
            if value == 0 {
                days = 30
            } else if value == 1 {
                days = 7
            } else if value == 2 {
                days = 1
            }
            let filtered = self.viewModel.output.historySnapshots.value.filter { snap in
                let correctFormat = snap.createdOn!.split(separator: ".")[0]
                let snapCreatedOn = Date.getFormattedDate(string: String(correctFormat), withTime: true)
                return Date.daysBetween(start: snapCreatedOn, end: Date()) <= days
            }
            self.viewModel.output.filteredSnapshots.value = filtered
        }).disposed(by: disposeBag)
    }
    
    func drawCharts(data: [SensorData]) {
        func convertStringToProperDate(snap: SensorData) -> Date {
            if self.timeSegmentedControl.selectedSegmentIndex != 2 {
                let correctFormat = snap.createdOn!.split(separator: " ")[0]
                return Date.getFormattedDate(string: String(correctFormat), withTime: false)
            } else {
                let correctFormat = snap.createdOn!.split(separator: ".")[0]
                return Date.getFormattedDate(string: String(correctFormat), withTime: true)
            }
        }
        
        func calculateAverage(dataArray: [(Date, Double)]) -> [Date: Double] {
            var averageDataDictionary = [Date: Double]()
            for data in dataArray {
                let (date, _) = data
                if averageDataDictionary[date] == nil {
                    let sameDateArray = dataArray.filter { (dateNext, value) -> Bool in
                        return date == dateNext
                    }
                    let sum = sameDateArray.reduce(0) { (result, arg1) -> Double in
                        let (_, value) = arg1
                        return result + value
                    }
                    averageDataDictionary[date] = sum/Double(sameDateArray.count)
                }
            }
            return averageDataDictionary
        }
        let value = self.timeSegmentedControl.selectedSegmentIndex
        var daysAgo = 30
        if value == 0 {
            daysAgo = 30
        } else if value == 1 {
            daysAgo = 7
        } else if value == 2 {
            daysAgo = 1
        }
        
        let dataPM100: [(Date, Double)] = data.map { (d) in
            let date = convertStringToProperDate(snap: d)
            return (date, Double(d.pm100!))
        }
        self.chartView1.daysAgo = daysAgo
        self.chartView1.data = calculateAverage(dataArray: dataPM100)
       
        
        let dataPM25: [(Date, Double)]  = data.map { (d) in
            let date = convertStringToProperDate(snap: d)
            return (date, Double(d.pm25!))
        }
        self.chartView2.daysAgo = daysAgo
        self.chartView2.data = calculateAverage(dataArray: dataPM25)
        
        
        let dataPM10: [(Date, Double)]  = data.map { (d) in
            let date = convertStringToProperDate(snap: d)
            return (date, Double(d.pm10!))
        }
        self.chartView3.daysAgo = daysAgo
        self.chartView3.data = calculateAverage(dataArray: dataPM10)
        
        
        let dataTemperature: [(Date, Double)]  = data.map { (d) in
            let date = convertStringToProperDate(snap: d)
            return (date, Double(d.temperature!))
        }
        self.chartView4.daysAgo = daysAgo
        self.chartView4.data = calculateAverage(dataArray: dataTemperature)
        
        
        let dataPressure: [(Date, Double)]  = data.map { (d) in
            let date = convertStringToProperDate(snap: d)
            return (date, Double(d.pressure!))
        }
        self.chartView5.daysAgo = daysAgo
        self.chartView5.data = calculateAverage(dataArray: dataPressure)
        
        
        let dataHumidity: [(Date, Double)]  = data.map { (d) in
            let date = convertStringToProperDate(snap: d)
            return (date, Double(d.humidity!))
        }
        self.chartView6.daysAgo = daysAgo
        self.chartView6.data = calculateAverage(dataArray: dataHumidity)
        
        
        let dataCO: [(Date, Double)]  = data.map { (d) in
            let date = convertStringToProperDate(snap: d)
            return (date, Double(d.CO!))
        }
        self.chartView7.daysAgo = daysAgo
        self.chartView7.data = calculateAverage(dataArray: dataCO)
        
    }
    
    func setupLayout() {
        self.view.addSubview(timeSegmentedControl)
        timeSegmentedControl.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, leading: self.view.leadingAnchor, bottom: nil, trailing: self.view.trailingAnchor, padding: .init(top: 5, left: 10, bottom: 0, right: 10))
        self.view.addSubview(scrollView)
        self.scrollView.anchor(top: timeSegmentedControl.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        self.scrollView.addSubview(chartStackView)
        chartStackView.anchor(top: self.scrollView.topAnchor, leading: self.scrollView.leadingAnchor, bottom: self.scrollView.bottomAnchor, trailing: scrollView.trailingAnchor)
        self.chartStackView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor, multiplier: 1.0).isActive = true
        
        self.chartView1 = ChartView(frame: .init(x: 0, y: 0, width: self.view.frame.width, height: 200), title: "PM 10")
        chartStackView.addArrangedSubview(chartView1)
        
        self.chartView2 = ChartView(frame: .init(x: 0, y: 0, width: self.view.frame.width, height: 200), title: "PM 2.5")
        chartStackView.addArrangedSubview(chartView2)
        
        self.chartView3 = ChartView(frame: .init(x: 0, y: 0, width: self.view.frame.width, height: 200), title: "PM 1.0")
        chartStackView.addArrangedSubview(chartView3)
        
        self.chartView4 = ChartView(frame: .init(x: 0, y: 0, width: self.view.frame.width, height: 200), title: "Temperature")
        chartStackView.addArrangedSubview(chartView4)
        
        self.chartView5 = ChartView(frame: .init(x: 0, y: 0, width: self.view.frame.width, height: 200), title: "Pressure")
        chartStackView.addArrangedSubview(chartView5)
        
        self.chartView6 = ChartView(frame: .init(x: 0, y: 0, width: self.view.frame.width, height: 200), title: "Humidity")
        chartStackView.addArrangedSubview(chartView6)
        
        self.chartView7 = ChartView(frame: .init(x: 0, y: 0, width: self.view.frame.width, height: 200), title: "CO")
        chartStackView.addArrangedSubview(chartView7)
    }
}


extension Date {
    static func getFormattedDate(string: String, withTime: Bool) -> Date {
        let dateFormatter = DateFormatter()
        let formatString = withTime ? "yyyy-MM-dd HH:mm:ss" : "yyyy-MM-dd"
        dateFormatter.dateFormat = formatString // This formate is input formated .
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        let formateDate = dateFormatter.date(from: string)!
        return formateDate
    }
}
