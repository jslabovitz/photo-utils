# coding: utf-8

module PhotoUtils

  # http://photo.net/medium-format-photography-forum/00LZPS
  # http://www.largeformatphotography.info/forum/showthread.php?t=2503
  # http://www.kenrockwell.com/tech/format.htm#120
  # http://www.mamiya.com/rb67-pro-sd-accessories-film-magazines,-holders-inserts-roll-film-magazines.html
  
  FORMATS = {}
    
  # from http://en.wikipedia.org/wiki/Image_sensor_format
  
  # name  height  width   aliases
  %q{
    1/6                       2.4   1.8
    1/4                       2.7   3.6
    1/3.6                     3     4
    1/3.2                     3.42  4.54
    1/3                       3.6   4.8
    1/2.7                     4.04  5.37
    1/2.5                     4.29  5.76
    1/2                       4.8   6.4
    1/1.8                     5.32  7.18
    1/1.7                     5.7   7.6     Canon PowerShot G9, Canon PowerShot G10
    1/1.6                     6.01  8.08
    2/3                       9.6   12.8
    1                         9.6   12.8
    4/3                       13    17.3
    
    APS-C                     14.8  22.2    Canon EOS DIGITAL REBEL XT, Canon EOS DIGITAL REBEL XTi, Canon EOS DIGITAL REBEL XSi, Canon EOS 450D
    APS-H                     19.1  28.7
    R-D1                      15.6  23.7    Epson R-D1, Epson R-D1s, Epson R-D1g, Epson R-D1x
    
    DX                        15.5  23.6    NIKON D70
    
    Leica S2                  30    45
                              
    35		                    24		36      FF, Canon EOS 5D
                              
    6x4.5		                  56		42      645
    6x4.5 short		            56		40.5
    6x4.5 Mamiya RB/RZ67	    56		41.5
    6x6                   		56		56
    6x6 short		              56		54
    6x7		                    56		72
    6x7 short		              56		69.5
    6x7 Mamiya RB/RZ67		    56		69.5
    6x7 Toyo		              56		67
    6x7 Horseman		          56		68
    6x7 Pentax		            55		70
    6x7 Cambo-Sinar-Wista		  56		70
    6x7 Linhof Super Rollex		56		72
    6x7 Linhof Rapid Rollex		57		76
    6x8		                    56		76
    6x9		                    56		84
    6x9 23 Graphic		        56		83
    6x9 Cambo-Horseman-Wista	56		82
    6x9 Toyo		              56		84
    6x9 Linhof		            56		85
    6x9 Sinar		              57		88
    6x10		                  56		92
    6x12		                  56		112
    6x12 Linhof		            57		120
    6x17		                  56		168
    6x17		                  56		168
  
    Polaroid 550		          92		126
    Polaroid 545		          95		122
    
    4x5 Quickload		          95		120
    4x5 Fidelity		          97		120
    
    5x7                       127   178
    8x10                      203   254
  
  }.split("\n").each do |s|
    case s.strip.sub(/#.*/, '')
    when /^(.*?)\s+([\d\.]+)\s+([\d\.]+)\s*(.*?)$/
      frame = Frame.new($2.to_f, $3.to_f)
      FORMATS[$1] = frame
      $4.split(/,\s*/).each do |eq|
        FORMATS[eq] = frame
      end
    when ''
      # ignore blank line
    else
      warn "Can't parse line: #{s.inspect}"
    end
  end

end