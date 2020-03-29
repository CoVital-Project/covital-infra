provider "heroku" {
  version = "~> 2.2"

  // required env vars:
  // HEROKU_EMAIL
  // HEROKU_API_KEY
}

data "heroku_team" "covital" {
  name = "covital"
}

resource "heroku_app" "pulseox-sandbox" {
  name   = "pulseox-sandbox"
  region = "us"

  acm = true

  organization {
    name     = data.heroku_team.covital.name
    locked   = false
    personal = false
  }

  config_vars = {
    # Only use this to set non-secret configs!
    # Set secrets via `heroku config:set` to keep them out of git
    VIDEO_UPLOAD_BUCKET_REGION = "us-east-2"
    NODE_ENV                   = "production"
  }

  internal_routing = false
  stack            = "heroku-18"

  buildpacks = [
    "heroku/nodejs"
  ]
}

resource "heroku_app" "pulseox-staging" {
  name   = "guarded-crag-28391"
  region = "us"

  acm = true

  organization {
    name     = data.heroku_team.covital.name
    locked   = false
    personal = false
  }

  config_vars = {
    # Only use this to set non-secret configs!
    # Set secrets via `heroku config:set` to keep them out of git
    VIDEO_UPLOAD_BUCKET_REGION = "us-east-2"
    NODE_ENV                   = "production"
  }

  internal_routing = false
  stack            = "heroku-18"

  buildpacks = [
    "heroku/nodejs"
  ]
}
