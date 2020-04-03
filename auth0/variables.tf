variable "auth0_callback_urls" {
  type    = map(list(string))
  default = {
    dev-us: ["https://localhost:9000/callback"]
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
