//
//  ViewController.swift
//  CLDatePicker
//
//  Created by darren on 2017/8/24.
//  Copyright © 2017年 陈亮陈亮. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func clickBtn1(_ sender: Any) {
        self.setupPicker()
    }
    func setupPicker() {
        let dataView = TestView()
        dataView.chooserSuccess = {[weak self] (str) in
        }
        UIApplication.shared.keyWindow?.addSubview(dataView)
    }

}

