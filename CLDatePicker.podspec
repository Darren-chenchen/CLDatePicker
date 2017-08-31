Pod::Spec.new do |s|
      s.name = 'CLDatePicker'
      s.version = '1.0.0'
      s.license = 'MIT'
      s.summary = 'datepick'
      s.homepage = 'https://github.com/Darren-chenchen/CLDatePicker'
      s.authors = { 'Darren-chenchen' => '1597887620@qq.com' }
      s.source = { :git => 'https://github.com/Darren-chenchen/CLDatePicker.git', :tag => s.version.to_s }

      s.ios.deployment_target = '8.0'

      s.source_files = 'CLImagePickerTool/CLImagePickerTool/**/*.swift'
      s.resource_bundles = { 
'CLImagePickerTool' => ['CLImagePickerTool/CLImagePickerTool/images/**/*.png','CLImagePickerTool/CLImagePickerTool/**/*.{xib,storyboard}','CLImagePickerTool/CLImagePickerTool/**/*.{lproj,strings}']
      }
    end
