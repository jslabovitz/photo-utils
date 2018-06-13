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
        formula = (ARGV.shift || 'neopan').to_sym
        range = 1..128
        ti = range.first
        until ti > range.last
          ti = TimeValue.new(ti)
          tc = reciprocity(ti, formula: formula)
          puts "%4s => %4s" % [ti, tc]
          ti *= 2
        end
      end

      # http://www.apug.org/forums/forum37/22334-fuji-neopan-400-reciprocity-failure-data.html
      # https://www.flickr.com/groups/477426@N23/discuss/72157635197694957/

      def reciprocity(time, formula: :neopan)
        time + case formula
        when :neopan
          0.3 * (time ** 1.62)
        when :portra
          0.870189 * (time ** 1.35815)
        else
          raise Error, "Can't compute reciprocity for #{formula.inspect}"
        end
      end

    end

  end

end