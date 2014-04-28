Pod::Spec.new do |s|

  s.name                  = "InspectorTabBar"
  s.version               = "0.0.1"
  s.summary               = "Tab bar like in the Xcode inspector. For information see http://www.stephanmichels.de/?p=107"
  s.homepage              = "https://github.com/smic/InspectorTabBar"
  s.license               = "none"
  s.author                = "smic"

  s.osx.deployment_target = "10.7"
  s.source                = { :git => "https://github.com/smic/InspectorTabBar.git",
                              :commit => '63daa7f84f78b853b42e2dabaf2d1720df77077d'
                            }
  s.source_files          = ['InspectorTabBar']
  s.exclude_files         = "Classes/Exclude"
  s.requires_arc          = true

end
