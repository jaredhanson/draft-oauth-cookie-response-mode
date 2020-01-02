---
docname: draft-hanson-oauth-cookie-response-mode-00
category: std

title: OAuth Cookie Response Mode
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

Introduction
