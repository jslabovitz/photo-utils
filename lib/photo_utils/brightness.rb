# coding: utf-8

module PhotoUtils

  class Brightness < Value
    
    #FIXME: Clarify usage between incident & reflected/spot metering
    
    CDM2_TO_FL = 0.2918635  # cd/m2 -> foot-Lambert
    LUX_TO_FL = 0.0929    # lux -> foot-Lambert
    K = 12.7              # reflected-light meter calibration constant (http://en.wikipedia.org/wiki/Light_meter#Calibration_constants)
                          # ranges from 10.6 to 13.4
                          # http://dougkerr.net/Pumpkin/articles/Exposure_metering_18.pdf
    C_FLAT = 250          # incident-light meter calibration constant (flat sensor)
    C_HEMISPHERICAL = 250 # incident-light meter calibration constant (hemispherical sensor)
    C = C_HEMISPHERICAL
    
    # amount specified in foot-Lambert
    
    def self.new_from_v(v)
      new(2 ** v.to_f)
    end
    
    def self.new_from_cdm2(cdm2)
      new(CDM2_TO_FL * cdm2)
    end
    
    def self.new_from_lux(lux)
      new(LUX_TO_FL * lux)
    end
    
    def to_v
      Math.log2(self.to_f)
    end
    
    def to_cdm2
      self * 3.4262591
    end
    
    def to_lux_equivalent
      self * 10.76
    end
    
    def to_s(format=:fL)
      case format
      when :fL
        "#{round} fL"
      when :cdm2
        "#{to_cdm2.round} cd/m2"
      when :lux_eq
        "#{to_lux_equivalent.round} lux-eq"
      when :value
        "Bv:#{to_v.prec(1)}"
      else
        raise "Unknown format: #{format.inspect}"
      end
    end
        
  end

end