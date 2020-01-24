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
browsers, it may be exposed to other applications with access to the resource
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

# Cookie Response Mode

This specification defines the Cookie Response Mode, which is described with its
response_mode parameter value:

cookie
: In this mode, the access token parameter of an authorization response is encoded
in a Set-Cookie HTTP header when responding to the client.

## Authorization Request

The client constructs the request URI as defined in Section 4.2.1 of
{{!RFC6749}}, and includes the response_mode extension parameter as defined by
this specification.

The client directs the resource owner to the constructed URI using an
HTTP redirection response, or by other means available to it via the user-agent.

For example, the client directs the user-agent to make the following HTTP
request using TLS (with extra line breaks for display purposes only):

~~~~~~~~~~
  GET /authorize?response_type=token&client_id=s6BhdRkqt3&state=xyz
      &redirect_uri=https%3A%2F%2Fclient%2Eexample%2Ecom%2Fcb
      &response_mode=cookie HTTP/1.1
  Host: server.example.com
~~~~~~~~~~

## Access Token Response

If the resource owner grants the access request, the authorization server issues
an access token and delivers it to the client by including an HTTP Set-Cookie
header in the redirection response to the client as defined by {{!RFC6265}}.
Any additional parameters other than the access token are added to the fragment
component of the redirection URI as defined in Section 4.2.2 of {{!RFC6749}}.

For example, the authorization server redirects the user-agent by sending the
following HTTP response (with extra line breaks for display purposes only):

~~~~~~~~~~
  HTTP/1.1 302 Found
  Location: http://example.com/cb#state=xyz&token_type=example
            &expires_in=3600
  Set-Cookie: at=2YotnFZFEjr1zCsicMWpAA; Path=/
~~~~~~~~~~

# Accessing Protected Resources

This specification describes how to use the HTTP state management mechanism
defined by {{!RFC6265}} to access protected resources.

## Bearer Token Usage

{{!RFC6750}} defines how to use bearer tokens in HTTP requests, primarily using
the WWW-Authenticate and Authorization HTTP headers defined by {{!RFC7235}}.

Many user-agent-based applications, particularly multi-page applications, do not
make use of the HTTP Authentication framework to authorize access to protected
resources.  Instead, these applications use cookies to establish a "session" for
subsequent requests to the server.  This section defines a method of sending
bearer access tokens in resource requests to resource servers that makes use of
the HTTP state management mechanism implemented by the user-agent within which a
user-agent-based application is executing.

### Cookie Request Header Field

When sending the access token using the HTTP state management mechanism, the
client uses the "Cookie" request header field to transmit the access token.

For example:

~~~~~~~~~~
  GET /resource HTTP/1.1
  Host: server.example.com
  Cookie: at=2YotnFZFEjr1zCsicMWpAA
  Accept: text/html
~~~~~~~~~~

This method is implemented by user-agents in such a way that the "Cookie"
request header field, and associated access token, are are automatically
presented by the client to the resource server, typically without any
involvement from the client developer.

For example, a multi-page application would make the above request when the
end-user clicks on a link:

~~~~~~~~~~
  <a href="https://server.example.com/resource">Resource</a>
~~~~~~~~~~

The corresponding HTTP POST request to the same endpoint would be made when the
end-user submits a form:

~~~~~~~~~~
  <form action="https://server.example.com/resource" method="post">
    <label for="description">Name:</label>
    <input type="text" id="description" name="description">
    <button type="submit">Update</button>
  </form>
~~~~~~~~~~

## Unauthenticated Requests

If the protected resource request does not include authentication credentials or
does not contain an access token that enables access to the protected resource,
the resource server MAY include the HTTP "WWW-Authenticate" response header
field.

If the resource server includes the HTTP "WWW-Authenticate" response header
field, it SHOULD use the auth-scheme value "Cookie" as defined by
{{!I-D.broyer-http-cookie-auth}}.

For example:

~~~~~~~~~~
  HTTP/1.1 401 Unauthorized
  WWW-Authenticate: Cookie realm="example"
                           form-action="/login"
                           cookie-name=at
  Content-Type: text/html
  
  <title>Unauthorized</title>
  <form action="/login" method="post">
    <label for="username">Username:</label>
    <input type="text" id="username" name="username">
    <label for="password">Password:</label>
    <input type="password" id="password" name="password">
    <button type="submit">Sign in</button>
  </form>
~~~~~~~~~~


# TODO

Discussion on 2 vs 3 legged?

Discuss cookie attributes like Expires and Path in relation to Resource servers and
token expiration times.

Works when authorization server and the resource server (and the client?) are
the same entity.
- Client may need to be same entity as AS, depending on browser cookie restrictinos
like ITP.
