require_relative 'test'

module PhotoUtils

  class LengthTest < Test

    def setup
      @table = {
    	  %q{∞}     => Float::INFINITY,
    	  %q{6"}    => 6.inches,
    	  %q{1'}    => 1.feet,
    	  %q{3'6"}  => 3.5.feet,
        # %q{100}   => 100.mm,
    	  %q{100mm} => 100.mm,
    	  %q{2m}    => 2.meters,
        %q{10.5m} => 10.5.meters,
      }
    end

    def test_formatting
      @table.each do |s, n|
        if s =~ /['"]/
          format = :imperial
        else
          format = nil
        end
        assert { Length.new(n).to_s(format) == s }
        assert { Length.parse(s) == n }
      end
    end

  end

end