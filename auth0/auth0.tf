/******************************************************************************** 
  Auth0 Client Application and API Resource definition
    You can initiate dev login by navigating to the following url:
      https://o2-monitoring-dev-us.auth0.com/authorize?client_id=5SvFE06CGaHu39AmPQmTa76X1TlibVUt&redirect_uri=https://openidconnect.net/callback&scope=openid%20profile%20email%20phone%20address&response_type=code&state=5d839812bfb8ed9fc398065b4f4a534e5bee5bc9
      
    Here are descriptions of parameters that should be passed from a mobile app 
      client_id:      Identifies the Auth0 Application to connect as
      audience:       Identifies the API access being requested
      redirect_uri:   Url to redirect back to upon login (should be a private-use URI like the following 
                      for a native app redirecting to a browser for auth:  org.covital.o2monitor:/oauth2redirect/covital_pulse_oximetry_client_dev)
      scope:          Scope for authentication regarding what information is required and what access is requested
      response_type:  Should be code to ensure
      code_challenge: PKCE code challenge (see https://tools.ietf.org/html/rfc7636)
      state:          CSRF token (https://tools.ietf.org/html/rfc6819#page-13)

  Uses the following workspaces to inject the correct variables for a specific environment
    dev-us
    prod-us

  Example commands to execute in dev
    export AUTH0_CLIENT_ID="<client-id from the Auth0 Management API Access application>"
    export AUTH0_CLIENT_SECRET="<client_secret from the Auth0 Management API Access application>"
    terraform workspace select dev-us
    terraform plan
    terraform apply
*/
provider "auth0" {
  domain = "o2-monitoring-${terraform.workspace}.auth0.com"
  /*
	Requires the following environment variables in lieu of checked-in config vars.
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
  callbacks                           = "${lookup(var.auth0_callback_urls, terraform.workspace)}"
  grant_types                         = ["authorization_code", "implicit", "refresh_token"]
  allowed_logout_urls                 = "${lookup(var.auth0_logout_urls, terraform.workspace)}"

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
# resource "auth0_client_grant" "covital_pulse_oximetry_client_grant" {
#   client_id = "auth0_client.covital_pulse_oximetry_client.id"
#   audience  = "auth0_resource_server.covital_pulse_oximetry_api.identifier"
#   scope     = ["read:user", "read:all"]
# }
