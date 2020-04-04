variable "auth0_callback_urls" {
  type    = map(list(string))
  default = {
    dev-us: ["https://localhost:9000/callback", "https://openidconnect.net/callback", "org.covital.o2monitor:/oauth2redirect/covital_pulse_oximetry_client_dev"]
    prod-us: ["org.covital.o2monitor:/oauth2redirect/covital_pulse_oximetry_client"]
  }
}

variable "auth0_logout_urls" {
  type    = map(list(string))
  default = {
    dev-us: ["https://localhost:9000/logout"]
  }
}

variable "auth0_end_user_api_audience" {
  type    = map(list(string))
  default = {
    dev-us: ["https://localhost:9000/callback"]
  }
}
