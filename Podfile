platform :osx, '10.7'

pod 'AFNetworking'
pod 'FormatterKit'
pod 'ISO8601DateFormatter'
#pod 'CorePlot', '1.0'

pod do |spec|
  spec.name         = 'NoodleKit'
  spec.version      = '0.0.1'
  spec.source       = { :git => 'https://github.com/mattt/NoodleKit.git',
                        :commit => '35d87663e359fe18d5cedb6818a446042dea5ed8'
                      }
  spec.source_files = '*.{h,m}'
  spec.clean_paths  = %w{English.lproj Examples NoodleKit.xcodeproj Info.plist README.md version.plist}
end

pod do |spec|
  spec.name         = "DMInspectorPalette"
  spec.version      = '0.0.1'
  spec.source       = {
                        :git => 'https://github.com/malcommac/DMInspectorPalette.git'
                      }
  spec.source_files = 'DMInspectorPalette/core'
  spec.requires_arc = true
end

pod do |spec|
  spec.name         = "InspectorTabBar"
  spec.version      = '0.0.1'
  spec.source       = {
                        :git => 'https://github.com/smic/InspectorTabBar.git'
                      }
  spec.source_files = ['InspectorTabBar/SMBar.{h,m}', 'InspectorTabBar/SMTabBar.{h,m}', 'InspectorTabBar/SMTabBarItem.{h,m}', 'InspectorTabBar/SMTabBarButtonCell.{h,m}', 'InspectorTabBar/NSDictionary+SMKeyValueObserving.{h,m}']
  spec.requires_arc = true
end
