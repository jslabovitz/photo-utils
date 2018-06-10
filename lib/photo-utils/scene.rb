module PhotoUtils

  class Scene

    attr_accessor :description
    attr_reader   :subject_distance
    attr_reader   :background_distance
    attr_accessor :camera
    attr_reader   :sensitivity
    attr_reader   :brightness

    def initialize(params={})
      {
        background_distance: Float::INFINITY,
        sensitivity: 100,
        brightness: 100,
      }.merge(params).each { |k, v| send("#{k}=", v) }
    end

    def sensitivity=(s)
      @sensitivity = SensitivityValue.new(s)
    end

    def brightness=(b)
      @brightness = BrightnessValue.new(b)
    end

    def subject_distance=(s)
      @subject_distance = Length.new(s)
    end

    def background_distance=(s)
      @background_distance = Length.new(s)
    end

    def circle_of_confusion
      # http://en.wikipedia.org/wiki/Circle_of_confusion
      @camera.format.frame.diagonal / 1750
    end

    def aperture_for_depth_of_field(near_limit, far_limit)
      a = ((@camera.lens.focal_length ** 2) / circle_of_confusion) * ((far_limit - near_limit) / (2 * near_limit * far_limit))
      ApertureValue.new(a)
    end

    def hyperfocal_distance
      # http://en.wikipedia.org/wiki/Hyperfocal_distance
      raise "Need focal length, aperture, and circle of confusion to determine hyperfocal distance" \
        unless @camera.lens.focal_length && @camera.lens.aperture && circle_of_confusion
      h = ((@camera.lens.focal_length ** 2) / (@camera.lens.aperture * circle_of_confusion)) + @camera.lens.focal_length
      Length.new(h)
    end

    def depth_of_field
      h = hyperfocal_distance
      s = subject_distance
      dof = HashStruct.new
      dof.near = (h * s) / (h + s)
      if s < h
        dof.far = (h * s) / (h - s)
      else
        dof.far = Float::INFINITY
      end
      dof.near = Length.new(dof.near)
      dof.far  = Length.new(dof.far)
      dof
    end

    def near_distance_from_subject
      d = subject_distance - depth_of_field.near
      Length.new(d)
    end

    def far_distance_from_subject
      d = depth_of_field.far.infinite? ? depth_of_field.far : (depth_of_field.far - subject_distance)
      Length.new(d)
    end

    def total_depth_of_field
      d = depth_of_field.far.infinite? ? depth_of_field.far : (depth_of_field.far - depth_of_field.near)
      Length.new(d)
    end

    def field_of_view(distance)
      raise "Need focal length and format size to determine field of view" unless @camera.lens.focal_length && @camera.format
      @camera.format.field_of_view(@camera.lens.focal_length, distance)
    end

    def magnification
      # http://en.wikipedia.org/wiki/Depth_of_field#Hyperfocal_magnification
      @camera.lens.focal_length / (subject_distance - @camera.lens.focal_length)
    end

    def subject_distance_for_field_of_view(fov)
      d_w = fov.width  / @camera.format.frame.width  * @camera.lens.focal_length
      d_h = fov.height / @camera.format.frame.height * @camera.lens.focal_length
      [d_w, d_h].max
    end

    # AKA bellows factor

    def working_aperture
      # http://en.wikipedia.org/wiki/F-number#Working_f-number
      ApertureValue.new((1 - magnification) * @camera.lens.aperture)
    end

    def blur_at_distance(d)
      # http://en.wikipedia.org/wiki/Depth_of_field#Foreground_and_background_blur
      xd = (d - subject_distance).abs
      b = (@camera.lens.focal_length * magnification) / @camera.lens.aperture
      if d < subject_distance
        b *= xd / (subject_distance - xd)
      else
        b *= xd / (subject_distance + xd)
      end
      # diameter of blur disk, in mm
      Length.new(b.mm)
    end

    def absolute_aperture
      @camera.lens.aperture.absolute(@camera.lens.focal_length)
    end

    def exposure
      Exposure.calculate(
        brightness: @brightness,
        sensitivity: @sensitivity,
        aperture: @camera.lens.aperture,
        time: @camera.shutter)
    end

    def calculate!
      exp = exposure
      @camera.lens.aperture = exp.aperture
      @camera.shutter = exp.time
    end

    def print_camera(io=STDOUT)
      io.puts "CAMERA:"
      io.puts "             name: #{@camera.name}"
      io.puts "           format: #{@camera.format} (35mm crop factor: #{@camera.format.crop_factor.round(1)})"
      io.puts "    shutter range: #{@camera.max_shutter} ~ #{@camera.min_shutter}"
      io.puts "   aperture range: #{@camera.lens.max_aperture} ~ #{@camera.lens.min_aperture}"
      io.puts "             lens: #{@camera.lens.name} - #{@camera.lens.focal_length} (#{
        %w{35 6x4.5 6x6 6x7 5x7}.map { |f| "#{f}: #{@camera.format.focal_length_equivalent(@camera.lens.focal_length, Format[f])}" }.join(', ')
      })"
      io.puts "    angle of view: #{@camera.angle_of_view}"
      io.puts "          shutter: #{@camera.shutter}"
      io.puts "         aperture: #{@camera.lens.aperture}"
      io.puts
    end

    def print_exposure(io=STDOUT)
      io.puts "EXPOSURE: #{exposure}"
    end

    def print_depth_of_field(io=STDOUT)
      io.puts "FIELD:"
      io.puts "     subject dist: #{subject_distance.to_s(:imperial)}"
      io.puts "      subject FOV: #{field_of_view(subject_distance).to_s(:imperial)}"
      io.puts "      subject mag: #{'%.2f' % magnification}x"
      io.puts "      subject DOF: #{total_depth_of_field.to_s(:imperial)} (-#{near_distance_from_subject.to_s(:imperial)}/+#{far_distance_from_subject.to_s(:imperial)})"
      io.puts "  background dist: #{background_distance.to_s(:imperial)}"
      unless background_distance.infinite?
        io.puts "   background FOV: #{field_of_view(background_distance).to_s(:imperial)}"
        io.puts "  background blur: #{blur_at_distance(background_distance)}"
      end
      io.puts "  hyperfocal dist: #{hyperfocal_distance.to_s(:imperial)}"
      io.puts " working aperture: #{working_aperture}"
      io.puts
    end

    def print(io=STDOUT)
      print_depth_of_field(io)
      print_exposure(io)
    end

  end

end