module PhotoUtils

  class Tools

    class Reciprocity < Tool

      def usage
        %q{
          -r 1      compute single value
          -r 2-60   compute values of 2 to 60
          -r        compute default range of 1-100 secs
        }
      end

      def run
        if ARGV.first
          r = ARGV.first.split('-', 2).map { |n| n ? n.to_i : nil }
        else
          r = 1..100
        end
        range = Range.new(r.first, r.last)
        ti = range.first
        until ti > range.last
          tc = reciprocity(TimeValue.new(ti))
          puts "#{ti} => #{tc.round.to_i}"
          ti *= 2
        end
      end

      # http://www.apug.org/forums/forum37/22334-fuji-neopan-400-reciprocity-failure-data.html

      def reciprocity(t)
        tc = t + (0.3 * (t ** 1.62))
        TimeValue.new(tc)
      end

    end

  end

end