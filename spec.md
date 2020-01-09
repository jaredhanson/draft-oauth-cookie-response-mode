---
docname: draft-hanson-oauth-cookie-response-mode-00
category: std

title: OAuth 2.0 Cookie Response Mode
author:
  -
    ins: J. Hanson
    name: Jared Hanson
    organization: Okta
    email: jared.hanson@okta.com

area: Security
workgroup: Web Authorization Protocol

--- abstract

This specification defines a response mode for OAuth 2.0 that uses a cookie to
issue an access token.  In this mode, the access token is encoded using an HTTP
Set-Cookie header and transmitted via the the HTTP Cookie header to the client.

--- middle

# Introduction

OAuth was initially created to allow third-party clients to access protected
resources hosted by a resource server, with the approval of the resource owner.
It has proven useful in first-party scenarios as well, where clients and
resource servers are managed by the same organization.

The implicit grant defined by OAuth is a flow optimized for clients implemented
in a browser using a scripting language such as JavaScript.  In this flow, the
client is issued the access token directly, where, due to the nature of
browsers, it may be exposed to to other applications with access to the resource
owner's user-agent.

Due to this, OAuth does not support issuance of refresh tokens via the implicit
grant, as refresh tokens are typically long-lasting credentials that must be
kept confidential and not exposed to unauthorized parties.

With the increasing adoption of OAuth, new threat models and security best
current practices have been identified in {{!I-D.ietf-oauth-security-topics}}
and {{!I-D.ietf-oauth-browser-based-apps}}.  These new practices recommend
the use of authorization code grant by browser-based applications and advise
against use of the implicit grant, a significant departure from the initial
specification of OAuth.

The rationale for the shift in guidance is sound, as the implicit grant is
susceptible to a number of a attack vectors that aren't applicable to
authorization code grant.  However, concerns around exposing tokens to
unauthorized parties with access to the user-agent remain, and may be
exacerbated if refresh tokens are introduced to an environment in which they
were previously forbidden.

These concerns are unavoidable, especially in scenarios where delegation is
granted to third-party clients.  However, first-party scenarios have the ability
to use cookies, which can be limited in such a way that they aren't exposed to
JavaScript.  Such limits mitigate various attack vectors, benefiting scenarios
in which use of cookies are applicable.

This specification defines a response mode for OAuth 2.0 that uses a cookie to
issue an access token.  In this mode, the access token is encoded using an HTTP
Set-Cookie header and transmitted via the the HTTP Cookie header to the client.

### Roles

Works when authorization server and the resource server (and the client?) are
the same entity.

Client may need to be same entity as AS, depending on browser cookie restrictinos
like ITP.


# Notes

Discussion on 2 vs 3 legged?



# Example

Something something

~~~~~~~~~~
  GET /authorize?response_type=token&client_id=s6BhdRkqt3&state=xyz
      &redirect_uri=https%3A%2F%2Fclient%2Eexample%2Ecom%2Fcb HTTP/1.1
  Host: server.example.com
~~~~~~~~~~

Something something

~~~~~~~~~~
  HTTP/1.1 302 Found
  Location: http://example.com/cb#state=xyz&token_type=example
            &expires_in=3600
  Set-Cookie: token=2YotnFZFEjr1zCsicMWpAA; Path=/
~~~~~~~~~~
