use godot::prelude::*;

use oauth2::reqwest;
use oauth2::{basic::BasicClient, StandardRevocableToken, TokenResponse};
use oauth2::{
    AuthUrl, AuthorizationCode, ClientId, ClientSecret, CsrfToken, PkceCodeChallenge, RedirectUrl,
    RevocationUrl, Scope, TokenUrl,
};
use oauth2::url::Url;
use std::env;
use std::io::{BufRead, BufReader, Write};
use std::net::TcpListener;


#[derive(GodotClass)]
#[class(base=Node, init)]
pub struct ROauth2
{
    #[export]
    client_id: GString,
    #[export]
    client_secret: GString,
    #[export]
    base_url: GString,

    base: Base<Node>
}


#[godot_api]
impl ROauth2
{

    fn _client_id(&self) -> ClientId
    {
        ClientId::new(
            env::var(self.client_id.to_string())
                .expect("missing client id")
        )
    }


    fn _client_secret(&self) -> ClientSecret
    {
        ClientSecret::new(env::var(self.client_secret.to_string()).expect("missing client secret"))
    }

    fn auth_url(&self) -> AuthUrl
    {
        AuthUrl::new("https://accounts.google.com/o/oauth2/v2/auth".to_string())
            .expect("Invalid Authorization endpoint URL")
    }

    fn token_url(&mut self) -> TokenUrl
    {
        TokenUrl::new("https://www.googleapis.com/oauth2/v3/token".to_string())
            .expect("Invalid token endpoint URL")
    }

    fn default_redirect_url() -> RedirectUrl
    {
        RedirectUrl::new("http://localhost:8080".to_string())
            .expect("Invalid redirect URL")
    }

    fn revocation_url() -> RevocationUrl
    {
        RevocationUrl::new("https://oauth2.googleapis.com/revoke".to_string())
            .expect("Invalid revocation endpoint URL")
    }

    fn init_google(&mut self)
    {

        let client = BasicClient::new(self._client_id())
            .set_client_secret(self._client_secret())
            .set_auth_uri(self.auth_url())
            .set_token_uri(self.token_url())
            .set_redirect_uri(
                Self::default_redirect_url()
            )
            .set_revocation_url(Self::revocation_url());

        let http_client = reqwest::blocking::ClientBuilder::new()
            .redirect(reqwest::redirect::Policy::none())
            .build()
            .expect("Client Should Build");

        let listener = TcpListener::bind("127.0.0.1:8080").unwrap();
        
        // Google supports Proof Key for Code Exchange (PKCE - https://oauth.net/2/pkce/).
        // Create a PKCE code verifier and SHA-256 encode it as a code challenge.
        let (pkce_code_challenge, pkce_code_verifier) = PkceCodeChallenge::new_random_sha256();

        // Generate the authorization URL to which we'll redirect the user.
        let (authorize_url, csrf_state) = client
            .authorize_url(CsrfToken::new_random)
            // This example is requesting access to the "calendar" features and the user's profile.
            .add_scope(Scope::new(
                "https://www.googleapis.com/auth/calendar".to_string(),
            ))
            .add_scope(Scope::new(
                "https://www.googleapis.com/auth/plus.me".to_string(),
            ))
            .set_pkce_challenge(pkce_code_challenge)
            .url();
        }

}