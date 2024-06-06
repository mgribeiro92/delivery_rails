Geocoder.configure(
  # Geocoding options
  timeout: 5,                 # geocoding service timeout (secs)
  lookup: :nominatim,         # name of geocoding service (see below for supported options)
  ip_lookup: :ipinfo_io,      # name of IP address geocoding service (see below for supported options)
  language: :en,              # ISO-639 language code
  use_https: true,            # use HTTPS for lookup requests? (if supported)
  units: :km,                 # :km for kilometers or :mi for miles
  distances: :linear          # :spherical or :linear
)
