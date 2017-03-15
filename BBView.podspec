Pod::Spec.new do |s|
  s.name         = 'BBView'
  s.version      = '1.0.1'
  s.summary      = 'UIView subclass leveraging block-based programming to improve non-subclassing customization capabilities'
  s.description  = <<-DESC
'This framework implements a UIView  subclass called BBView.  This class includes three main capabilities.  The first one is adding setFrameBlock and layoutSubviewsBlock properties which allow developers to append the typical setFrame and layoutSubviews code of UIView in order to allow effective management of subviews while resizing.  Supplementing this is the ability to set identifier string for subviews.  This class also allows developers to add action blocks to gesture recognizers as an alternative to the addTarget:Action: method.  Finally, this class has a delegate object with several delegate methods which also append their respective UIView methods with additional code for further customization.'
                   DESC
  s.homepage     = 'https://github.com/cfeenstra67/BBView'
  s.license      = {:type => 'MIT'}
  s.author     	 = { 'cfeenstra67' => 'cameron.l.feenstra@gmail.com' }
  s.platform     = :ios
  s.source       = { :git => 'https://github.com/cfeenstra67/BBView.git', :tag => 'v1.0' }
  s.source_files  = 'BBView', 'BBView/**/*.{h,m}'
end
