module PhotoUtils

  module Constants

    # https://en.wikipedia.org/wiki/Light_meter#Calibration_constants

    N = 2 ** Rational(-7, 4)    # APEX
    # N = Rational(1, 3.125)      # EXIF

    #
    # incident-light meter calibration constant
    #

    C = 224     # APEX
    # C = 250   # flat receptor
    # C = 320   # Minolta
    # C = 340   # Sekonic

    #
    # reflected-light meter calibration constant
    #

    K = 11.4    # APEX
    # K = 12.5  # Canon, Nikon, Sekonic
    # K = 14    # Minolta, Kenko, Pentax

    ISO_BASE = 3.125

  end

end