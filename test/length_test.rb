require_relative 'test'

module PhotoUtils

  class TestLength < Test

    def setup
      @table = {
    	  %q{∞}     => Math::Infinity,
    	  %q{6"}    => 6.inches,
    	  %q{1'}    => 1.feet,
    	  %q{3'6"}  => 3.5.feet,
        # %q{100}   => 100.mm,
    	  %q{100mm} => 100.mm,
    	  %q{2m}    => 2.meters,
        %q{10.5m} => 10.5.meters,
      }
    end

    def test_formatter
      @table.each do |s, n|
        if s =~ /['"]/
          format = :imperial
        else
          format = :metric
        end
        assert { Length.new(n).to_s(format) == s }
      end
    end

    def test_parse
  	  @table.each do |s, n|
        assert { Length.new(s) == n }
      end
    end

  end

end