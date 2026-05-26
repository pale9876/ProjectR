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
    #[init(val=GString::from("56695e67-fc00-4d9b-9a8c-6147223593f4"))]
    client_id: GString,
    #[export]
    #[init(val=GString::from("pwN8BkQmM6EOqdHYwFPOFuOkSKZt/oQAfWHXw/kNEKE="))]
    client_secret: GString,


    base: Base<Node>
}





#[godot_api]
impl ROauth2
{
    const CIME_BASE_URL: &str = "https://ci.me/api/openapi";
    const USER_API: &str = "/open/v1/users/me";

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
        AuthUrl::new("https://ci.me/auth/openapi/account-interlock".to_string())
            .expect("Invalid Authorization endpoint URL")
    }

    fn token_url(&mut self) -> TokenUrl
    {
        TokenUrl::new("https://ci.me/api/openapi/auth/v1/token".to_string())
            .expect("Invalid token endpoint URL")
    }

    fn default_redirect_url() -> RedirectUrl
    {
        RedirectUrl::new("https://localhost:8080".to_string())
            .expect("Invalid redirect URL")
    }

    fn revocation_url() -> RevocationUrl
    {
        RevocationUrl::new("https://ci.me/api/openapi/auth/v1/token/revoke".to_string())
            .expect("Invalid revocation endpoint URL")
    }

    #[func]
    fn start(&mut self)
    {
        let client = BasicClient::new(self._client_id())
            .set_client_secret(self._client_secret())
            .set_auth_uri(self.auth_url())
            .set_token_uri(self.token_url())
            .set_redirect_uri(Self::default_redirect_url())
            .set_revocation_url(Self::revocation_url());
            

        let http_client = reqwest::blocking::ClientBuilder::new()
            .redirect(reqwest::redirect::Policy::none())
            .build()
            .expect("Client Should Build");

        let listener = TcpListener::bind("127.0.0.1:8080").unwrap();
    
        let (authorize_url, csrf_state) = client
            .authorize_url(CsrfToken::new_random)
            // This example is requesting access to the user's public repos and email.
            .add_scope(Scope::new("public_repo".to_string()))
            .add_scope(Scope::new("user:email".to_string()))
            .url();

        let (code, state) = {
            // A very naive implementation of the redirect server.
            let listener = TcpListener::bind("127.0.0.1:8080").unwrap();
    
            // The server will terminate itself after collecting the first code.
            let Some(mut stream) = listener.incoming().flatten().next() else {
                panic!("listener terminated without accepting a connection");
            };
    
            let mut reader = BufReader::new(&stream);
    
            let mut request_line = String::new();
            reader.read_line(&mut request_line).unwrap();
    
            let redirect_url = request_line.split_whitespace().nth(1).unwrap();
            let url = Url::parse(&("http://localhost".to_string() + redirect_url)).unwrap();
    
            let code = url
                .query_pairs()
                .find(|(key, _)| key == "code")
                .map(|(_, code)| AuthorizationCode::new(code.into_owned()))
                .unwrap();
    
            let state = url
                .query_pairs()
                .find(|(key, _)| key == "state")
                .map(|(_, state)| CsrfToken::new(state.into_owned()))
                .unwrap();
    
            let message = "Go back to your terminal :)";
            let response = format!(
                "HTTP/1.1 200 OK\r\ncontent-length: {}\r\n\r\n{}",
                message.len(),
                message
            );
            stream.write_all(response.as_bytes()).unwrap();
    
            (code, state)
        };

        let token_res = client.exchange_code(code).request(&http_client);

        if let Ok(token) = token_res
        {
            // NB: Github returns a single comma-separated "scope" parameter instead of multiple
            // space-separated scopes. Github-specific clients can parse this scope into
            // multiple scopes by splitting at the commas. Note that it's not safe for the
            // library to do this by default because RFC 6749 allows scopes to contain commas.
            let scopes = if let Some(scopes_vec) = token.scopes() {
                scopes_vec
                    .iter()
                    .flat_map(|comma_separated| comma_separated.split(','))
                    .collect::<Vec<_>>()
            }
            else
            {
                Vec::new()
            };
        }
    }
}