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
Set-Cookie header and transmitted via the the HTTP Cookie header to the client
or resource server.

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
Set-Cookie header and transmitted via the the HTTP Cookie header to the client
or resource server.

## Notational Conventions

{::boilerplate bcp14}

# Cookie Response Mode

This specification defines the Cookie Response Mode, which is described with its
response_mode parameter value:

cookie
: In this mode, the access token parameter of an authorization response is encoded
in a Set-Cookie HTTP header when responding to the client.

# User-Agent-based Applications

This specification applies to user-agent-based applications, which is a client
profile defined in Section 2.1 of {{!RFC6749}}.  A user-agent-based application
is a public client in which the client code is downloaded from a web server and
executes within a user-agent (e.g., web browser) on the device used by the
resource owner.  Protocol data and credentials are easily accessible (and often
visible) to the resource owner.  Since such applications reside within the
user-agent, they can make seamless use of the user-agent capabilities when
requesting authorization.

This specification has been designed around the following user-agent-based
application profiles, representing common architectual patterns for building web
applications:

multi-page application
: A multi-page application (MPA) is a user-agent-based application that
interacts with the user using hypertext, where each interaction triggers
a request to a server which responds with a new page that is loaded into the
browser.  A MPA makes use of HTML links, forms, and HTTP redirects.

single-page application
: A single-page application (SPA) is a user-agent-based application that
interacts with the user by dynamically rewriting the current page rather than
loading entire new pages from a server.  A SPA makes use of JavaScript and web
browser APIs.

hybrid application
: A hybrid application is a user-agent-based application that interacts with the
user using both hypertext and dynamic scripting.  A hybrid application makes use
of both HTML and/or JavaScript within a single page and the entirety of the
application may span multiple pages.



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
