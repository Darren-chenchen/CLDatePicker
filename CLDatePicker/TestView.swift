//
//  SplFiltFormView.swift
//  paso-ios
//
//  Created by darren on 2017/8/15.
//  Copyright © 2017年 陈亮陈亮. All rights reserved.
//

import UIKit

typealias chooseDataCompleteClouse = (String)->()

class TestView: UIView {
    
    let contentH: CGFloat = 280 // 该空间的高度
    let headerH: CGFloat = 56  // 头部控件的高度
    let KScreenWidth = UIScreen.main.bounds.size.width
    let KScreenHeight = UIScreen.main.bounds.size.height
    let win = UIApplication.shared.keyWindow

    var bottomView: UIView?
    
    var modelArr: [String]?
    
    var chooserSuccess: chooseDataCompleteClouse?
    
    var selectedDate: Date?
    
    lazy var coverView: UIView = {
        let cover = UIView.init(frame: (self.win?.bounds)!)
        cover.backgroundColor = UIColor(white: 0, alpha: 0.65)
        cover.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(clickCover)))
        return cover
    }()
    
    lazy var pickView: CLDatePicker = {
        let pick = CLDatePicker.init(frame: CGRect(x:0,y:self.headerH,width:self.KScreenWidth,height:self.contentH-self.headerH))
        return pick
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        // 添加背景
        win?.addSubview(self.coverView)
        
        // 内容
        self.bottomView = UIView.init(frame: CGRect(x: 0, y: KScreenHeight, width: KScreenWidth, height: self.contentH))
        self.bottomView?.backgroundColor = UIColor.white
        win?.addSubview(self.bottomView!)
        UIView.animate(withDuration: 0.25) {
            self.bottomView?.hd_y = self.KScreenHeight-self.contentH
        }
        
        // 头部
        let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: self.headerH))
        bottomView?.addSubview(headerView)
        
        let cancelBtn = UIButton.init(frame: CGRect(x: 5, y: 0, width: 60, height: self.headerH))
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(UIColor.blue, for: .normal)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cancelBtn.addTarget(self, action: #selector(clickCancelBtn), for: .touchUpInside)
        headerView.addSubview(cancelBtn)
        
        let titleLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 120, height: self.headerH))
        titleLabel.hd_centerX = headerView.hd_centerX
        titleLabel.text = "选择年/月/日"
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        headerView.addSubview(titleLabel)
        
        let addBtn = UIButton.init(frame: CGRect(x: KScreenWidth-65, y: 0, width: 60, height: self.headerH))
        addBtn.setTitle("完成", for: .normal)
        addBtn.setTitleColor(UIColor.blue, for: .normal)
        addBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        addBtn.addTarget(self, action: #selector(clickAddBtn), for: .touchUpInside)
        headerView.addSubview(addBtn)
        
        self.bottomView?.addSubview(self.pickView)
        
        self.pickView.selectedTitleColor = UIColor.red
        self.selectedDate = Date()
        self.pickView.maxDate = Date()
        self.pickView.datePickerValueChange = { [weak self] (yearStr,monthStr,dayStr) in
            print("\(yearStr)===\(monthStr)====\(dayStr)")
        }
    }
    
    
    func clickCancelBtn() {
        self.dismiss()
    }
    
    func clickAddBtn() {
        
        let dateStr = self.dateStringWithDate(date: self.selectedDate!, DateFormatStr: "yyyy-MM-dd")
        
        if self.chooserSuccess != nil {
            self.chooserSuccess!(dateStr)
        }
        
        self.dismiss()
    }
    
    func clickCover() {
        self.dismiss()
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.25, animations: {
            self.bottomView?.hd_y = self.KScreenHeight
        }) { (finish) in
            self.bottomView?.removeFromSuperview()
            self.coverView.removeFromSuperview()
            self.bottomView = nil
            self.removeFromSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dateStringWithDate(date:Date,DateFormatStr:String) -> String {
        // 日期格式化类
        let fmt = DateFormatter()
        // 设置日期格式(y:年,M:月,d:日,H:时,m:分,s:秒)
        fmt.dateFormat = DateFormatStr
        
        return fmt.string(from: date)
    }
}
