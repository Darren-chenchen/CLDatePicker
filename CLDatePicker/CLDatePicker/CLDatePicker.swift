//
//  CLDatePicker.swift
//  CLDatePicker
//
//  Created by darren on 2017/8/24.
//  Copyright © 2017年 陈亮陈亮. All rights reserved.
//

import UIKit

typealias datePickerValueChangeClouse = (String,String,String)->()

class CLDatePicker: UIView {
    
    var datePickerValueChange: datePickerValueChangeClouse?
    
    lazy var pickView: UIPickerView = {
        let pick = UIPickerView.init(frame: self.bounds)
        pick.delegate = self
        pick.dataSource = self
        return pick
    }()
    
    var yearArr = [String]()
    var monthsArr = [String]()
    var dayArr = [String]()
    // 设置选中状态的文字颜色
    var selectedTitleColor = UIColor.black {
        willSet (new){ // 属性即将改变,还未改变时会调用的方法
            // 在该方法中有一个默认的系统属性newValue,用于存储新值
            self.selectedTitleColor = new
            self.pickView.reloadAllComponents()
        }
    }
    // 设置选中状态的文字颜色
    var selectedTitleFont = UIFont.systemFont(ofSize: 24)  {
        willSet (new){ // 属性即将改变,还未改变时会调用的方法
            // 在该方法中有一个默认的系统属性newValue,用于存储新值
            self.selectedTitleFont = new
            self.pickView.reloadAllComponents()
        }
    }
    
    // 设置选中的日期，默认选中当前日期
    var defaultSelectDate = Date()
    // 设置当前选中的日期
    var currentSelectDate = Date()
    // 设置最大可以显示到的日期,默认是今天
    var maxDate: Date?
    // 记录当前选中的行
    var currentRow1: Int?
    var currentRow2: Int?
    var currentRow3: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.pickView)
        
        for i in 1..<10000 {
            self.yearArr.append("\(i)年")
        }
        for i in 1..<13 {
            self.monthsArr.append("\(i)月")
        }
        
        // 设置默认选中的行
        let calendar = NSCalendar.current
        let defYear = calendar.component(.year, from: self.defaultSelectDate)
        let defMonth = calendar.component(.month, from: self.defaultSelectDate)
        let defDay = calendar.component(.day, from: self.defaultSelectDate)
        self.getDaysInMonth(year: defYear, month: defMonth)
        
        self.pickView.selectRow(defYear-1, inComponent: 0, animated: true)
        self.pickView.selectRow(defMonth-1, inComponent: 1, animated: true)
        self.pickView.selectRow(defDay-1, inComponent: 2, animated: true)
        
        // 初始化默认选中的行
        self.currentRow1 = defYear-1
        self.currentRow2 = defMonth-1
        self.currentRow3 = defDay-1
        
        // 由于执行先后顺序问题，延迟执行
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.2) {
            // 传递数据给外界
            self.dealDateStr()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 获取某年某月总共多少天
    func getDaysInMonth(year:Int,month:Int) {
        self.dayArr.removeAll()
        if month == 1 ||  month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12 {
            for i in 1..<32 {
                self.dayArr.append("\(i)日")
            }
        } else if month == 4 ||  month == 6 || month == 9 || month == 11 {
            for i in 1..<31 {
                self.dayArr.append("\(i)日")
            }
        } else {
            if year%100 == 0 {
                if year%400 == 0 {
                    for i in 1..<30 {
                        self.dayArr.append("\(i)日")
                    }
                } else {
                    for i in 1..<29 {
                        self.dayArr.append("\(i)日")
                    }
                }
            } else {
                if year%4 == 0 {
                    for i in 1..<30 {
                        self.dayArr.append("\(i)日")
                    }
                } else {
                    for i in 1..<29 {
                        self.dayArr.append("\(i)日")
                    }
                }
            }
        }
    }
}

extension CLDatePicker: UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return self.yearArr.count
        } else if component == 1 {
            return self.monthsArr.count
        } else {
            return self.dayArr.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return self.yearArr[row]
        } else if component == 1 {
            return self.monthsArr[row]
        } else {
            return self.dayArr[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        
        if component == 0 && row == self.currentRow1{
            label.textColor = self.selectedTitleColor
            label.font = self.selectedTitleFont
        } else if component == 1 && row == self.currentRow2{
            label.textColor = self.selectedTitleColor
            label.font = self.selectedTitleFont
        } else if component == 2 && row == self.currentRow3{
            label.textColor = self.selectedTitleColor
            label.font = self.selectedTitleFont
        } else {
            label.textColor = UIColor.black
            label.font = UIFont.systemFont(ofSize: 24)
        }
        
        if component == 0 {
            label.textAlignment = .right
        } else if component == 2 {
            label.textAlignment = .left
        } else {
            label.textAlignment = .center
        }
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // 获取当前界面展示的年月日
        let nowYear = self.yearArr[self.pickView.selectedRow(inComponent: 0)]
        let year = Int(nowYear.substring(to:nowYear.index(nowYear.startIndex, offsetBy: nowYear.characters.count-1))) ?? 1
        
        let nowMonth = self.monthsArr[self.pickView.selectedRow(inComponent: 1)]
        let month = Int(nowMonth.substring(to:nowMonth.index(nowMonth.startIndex, offsetBy: nowMonth.characters.count-1))) ?? 1
        
        let nowDay = self.dayArr[self.pickView.selectedRow(inComponent: 2)]
        let day = Int(nowDay.substring(to:nowDay.index(nowDay.startIndex, offsetBy: nowDay.characters.count-1))) ?? 1
        
        // 月份更新日期
        if component == 1 || component == 0{
            self.getDaysInMonth(year: year, month: month)
            self.pickView.reloadComponent(2)
        }
        
        if component == 0 {
            self.currentRow1 = row
            self.pickView.reloadComponent(0)
        } else if component == 1{
            self.currentRow2 = row
            self.pickView.reloadComponent(1)
        } else {
            self.currentRow3 = row
            self.pickView.reloadComponent(2)
        }
        
        // 传递数据给外界
        self.dealDateStr()
        
        
        // 设置了最大日期，如果超过就自动滚到最大日期
        if self.maxDate != nil {
            
            if self.adjustDate() == 1 {
                let calendar = NSCalendar.current
                let maxYear = calendar.component(.year, from: self.maxDate!)
                let maxMonth = calendar.component(.month, from: self.maxDate!)
                let maxDay = calendar.component(.day, from: self.maxDate!)
                
                // 如果超过了最大年份，或者最大月份，或者最大日期，就自动返回到最大日期
                if year > maxYear {
                    self.pickView.selectRow(maxYear-1, inComponent: 0, animated: true)
                    self.currentRow1 = maxYear-1
                    self.pickView.reloadComponent(0)
                }
                if month > maxMonth {
                    self.pickView.selectRow(maxMonth-1, inComponent: 1, animated: true)
                    self.currentRow2 = maxMonth-1
                    self.pickView.reloadComponent(1)
                }
                if day > maxDay {
                    self.pickView.selectRow(maxDay-1, inComponent: 2, animated: true)
                    self.currentRow3 = maxDay-1
                    self.pickView.reloadComponent(2)
                }
                
                self.dealDateStr()

            }
        }
    }
    
    // 比较日期
    func adjustDate() -> Int{
        let result: ComparisonResult = self.currentSelectDate.compare(self.maxDate!)
        return result.rawValue
    }
    
    func dealDateStr() {
        if datePickerValueChange != nil {
            
            let passYear = self.yearArr[self.currentRow1!]
            let year = passYear.substring(to:passYear.index(passYear.startIndex, offsetBy: passYear.characters.count-1))
            
            let passMonth = self.monthsArr[self.currentRow2!]
            var month = passMonth.substring(to:passMonth.index(passMonth.startIndex, offsetBy: passMonth.characters.count-1))
            
            let passDay = self.dayArr[self.currentRow3!]
            var day = passDay.substring(to:passDay.index(passDay.startIndex, offsetBy: passDay.characters.count-1))
            
            if month.characters.count == 1 {
                month = "0" + month
            }
            if day.characters.count == 1 {
                day = "0" + day
            }
            self.datePickerValueChange!(year,month,day)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let str = year+"-"+month+"-"+day
            let date = formatter.date(from: str)
            self.currentSelectDate = date!
        }
    }
}
