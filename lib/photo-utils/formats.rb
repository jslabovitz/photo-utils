module PhotoUtils

  class Format

    # http://photo.net/medium-format-photography-forum/00LZPS
    # http://www.largeformatphotography.info/forum/showthread.php?t=2503
    # http://www.kenrockwell.com/tech/format.htm#120
    # http://www.mamiya.com/rb67-pro-sd-accessories-film-magazines,-holders-inserts-roll-film-magazines.html
    # from http://en.wikipedia.org/wiki/Image_sensor_format

    # name  height  width   aliases
    FormatDescriptions = %q{
      1/6                         2.4   1.8
      1/4                         2.7   3.6
      1/3.6                       3     4
      1/3.2                       3.42  4.54
      1/3                         3.6   4.8
      1/2.7                       4.04  5.37
      1/2.5                       4.29  5.76
      1/2                         4.8   6.4
      1/1.8                       5.32  7.18
      1/1.7                       5.7   7.6     Canon PowerShot G9, Canon PowerShot G10
      1/1.6                       6.01  8.08
      2/3                         9.6   12.8
      1                           9.6   12.8
      4/3                         13    17.3

      APS-C                       14.8  22.2    Canon EOS DIGITAL REBEL XT, Canon EOS DIGITAL REBEL XTi, Canon EOS DIGITAL REBEL XSi, Canon EOS 450D
      APS-H                       19.1  28.7
      R-D1                        15.6  23.7    Epson R-D1, Epson R-D1s, Epson R-D1g, Epson R-D1x

      DX                          15.5  23.6    NIKON D70

      Leica S2                    30    45

      35		                      24		36      FF, Canon EOS 5D

      6x4.5		                    56		42      645
      6x4.5 short		              56		40.5
      6x4.5 Mamiya RB/RZ67	      56		41.5
      6x6                   		  56		56
      6x6 short		                56		54
      6x7		                      56		72
      6x7 short		                56		69.5
      6x7 Mamiya RB/RZ67		      56		69.5
      6x7 Toyo		                56		67
      6x7 Horseman		            56		68
      6x7 Pentax		              55		70
      6x7 Cambo-Sinar-Wista		    56		70
      6x7 Linhof Super Rollex		  56		72
      6x7 Linhof Rapid Rollex		  57		76
      6x8		                      56		76
      6x9		                      56		84
      6x9 23 Graphic		          56		83
      6x9 Cambo-Horseman-Wista	  56		82
      6x9 Toyo		                56		84
      6x9 Linhof		              56		85
      6x9 Sinar		                57		88
      6x10		                    56		92
      6x12		                    56		112
      6x12 Linhof		              57		120
      6x17		                    56		168
      6x17		                    56		168

      Polaroid 660                73    95
      Polaroid 660 on Mamiya RB/RZ67    73    73

      Polaroid 550		            92		126
      Polaroid 545		            95		122
      4x5 Quickload		            95		120
      4x5 Fidelity		            97		120     4x5

      5x7                         127   178

      8x10                        203   254
    }

    def self.load_formats
      @@formats = {}
      FormatDescriptions.split("\n").each do |line|
        case line.sub(/#.*/, '').strip
        when /^(.*?)\s{2,}([\d\.]+)\s+([\d\.]+)\s*(.*?)$/
          name, height, width, aliases = $1, $2, $3, $4
          frame = Frame.new(width.to_f, height.to_f)
          format = Format.new(name: name, frame: frame)
          @@formats[name] = format
          aliases.split(/,\s*/).each { |a| @@formats[a] = format }
        when ''
          # ignore blank line
        else
          raise "Can't parse format line: #{line.inspect}"
        end
      end
    end

    def self.[](name)
      load_formats unless class_variable_defined?('@@formats')
      @@formats[name]
    end

    attr_accessor :name
    attr_accessor :frame

    def initialize(params={})
      params.each { |k, v| send("#{k}=", v) }
    end

    def inspect
      "<#{self.class} name=#{@name.inspect} frame=#{@frame.inspect}>"
    end

    def to_s(short=true)
      if short
        @name
      else
        "#{@name} (#{@frame})"
      end
    end

    def focal_length_equivalent(focal_length, other=Format['35'])
      f = focal_length * crop_factor(other)
      Length.new(f)
    end

    def aperture_equivalent(aperture, other=Format['35'])
      f = aperture * crop_factor(other)
      Aperture.new(f)
    end

    def crop_factor(other=Format['35'])
      # http://en.wikipedia.org/wiki/Crop_factor
      other.frame.diagonal / @frame.diagonal
    end

    def angle_of_view(focal_length)
      # http://imaginatorium.org/stuff/angle.htm
      # http://en.wikipedia.org/wiki/Angle_of_view
      a = Math.arcdeg(2 * Math.atan(@frame.diagonal / (2 * focal_length)))
      Angle.new(a)
    end

    def field_of_view(focal_length, subject_distance)
      # http://en.wikipedia.org/wiki/Field_of_view
      Frame.new(
        subject_distance * (@frame.height / focal_length),
        subject_distance * (@frame.width  / focal_length))
    end

  end

end
