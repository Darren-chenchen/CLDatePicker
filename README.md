# CLDatePicker
自定义时间选择器，支持设置选中状态的文字颜色


# 使用方式：
#### 由于不同项目的UI界面不同，所以这里只是封装了一个类似PickView的控件，创建CLDatePicker,然后将该控件放置到指定的UI界面上
		
		lazy var pickView: CLDatePicker = {
        let pick = CLDatePicker.init(frame: CGRect(x:0,y:self.headerH,width:self.KScreenWidth,height:self.contentH-self.headerH))
        return pick
   		 }()
    
    	self.pickView.selectedTitleColor = UIColor.red
    	// 设置选中的日期，不设置的话默认是今天
        self.selectedDate = Date()
        // 设置最大可现实的日期，如果超过该日期就自动回滚
        self.pickView.maxDate = Date()
        // 选中日期的回调
        self.pickView.datePickerValueChange = { [weak self] (yearStr,monthStr,dayStr) in
            print("\(yearStr)===\(monthStr)====\(dayStr)")
        }
        
        

# 效果图

![logo](http://images2017.cnblogs.com/blog/818253/201708/818253-20170825114214043-611262458.png)