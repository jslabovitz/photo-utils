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
    
    def self.new_from_v(v)
      new(2 ** v.to_f)
    end
    
    def self.new_from_cdm2(cdm2)
      new(N * cdm2)
    end
    
    def self.new_from_lux(lux)
      new(N * lux)
    end
    
    def to_v
      Math.log2(self.to_f)
    end
    
    def to_s(format=:fL)
      case format
      when :fL
        "#{round} fL"
      when :value
        "Bv:#{to_v.prec(1)}"
      else
        raise "Unknown format: #{format.inspect}"
      end
    end
        
  end

end