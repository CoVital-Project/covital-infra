// Auth0 Client Application and API Resource definition

provider "auth0" {
  /*
	Requires the following environment variables in lieu of checked-in config vars.
    export AUTH0_DOMAIN="<domain>.auth0.com" (currently he-sandbox.auth0.com)
    export AUTH0_CLIENT_ID="<client-id from the Auth0 Management API Access application>"
    export AUTH0_CLIENT_SECRET="<client_secret from the Auth0 Management API Access application>"
	*/
}

# Create new Application in Auth0
resource "auth0_client" "covital_pulse_oximetry_client" {
  name                                = "CoVital Pulse Oximetry Native App"
  description                         = "Authentication Client for CoVital Pulse Oximetry project"
  app_type                            = "regular_web"
  custom_login_page_on                = false
  is_first_party                      = true
  is_token_endpoint_ip_header_trusted = false
  token_endpoint_auth_method          = "none"
  oidc_conformant                     = true
  logo_uri                            = "https://i.imgur.com/CAlshnW.png"
  callbacks                           = ["https://localhost:9000/callback"]
  grant_types                         = ["authorization_code", "implicit", "refresh_token"]
  allowed_logout_urls                 = ["https://localhost:9000"]

  jwt_configuration {
    lifetime_in_seconds = 1200
    secret_encoded      = true
    alg                 = "RS256"

    scopes = {
      foo = "bar"
    }
  }

  /*mobile {
    android {
      app_package_name = "some package name"
      sha256_cert_fingerprints = "xxxxxxxxxxx"
    }
    ios {
      team_id = "9JA89QQLNQ"
      app_bundle_identifier = "com.my.bundle.id"
    }
  }*/
}

# Create new API resource in Auth0
resource "auth0_resource_server" "covital_pulse_oximetry_api" {
  name       = "Pulse Oximetry Data Collection API"
  identifier = "https://pulseox-sandbox.herokuapp.com/"

  scopes {
    value       = "read:user"
    description = "Ability to read data for my user"
  }

  scopes {
    value       = "read:all"
    description = "Ability to read data for all users"
  }
}

# Grant access to API from Application with read:user and read:all grants
resource "auth0_client_grant" "covital_pulse_oximetry_client_grant" {
  client_id = "auth0_client.covital_pulse_oximetry_client.id"
  audience  = "auth0_resource_server.covital_pulse_oximetry_api.identifier"
  scope     = ["read:user", "read:all"]
}
