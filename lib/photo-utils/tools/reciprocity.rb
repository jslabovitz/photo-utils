require 'photo-utils/tool'

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
        if @args.first
          r = @args.first.split('-', 2).map { |n| n ? n.to_i : nil }
        else
          r = 1..100
        end
        range = Range.new(r.first, r.last)
        ti = range.first
        until ti > range.last
          tc = Time.new(ti).reciprocity
          puts "#{ti} => #{tc.round.to_i}"
          ti *= 2
        end
      end

    end

  end

end