---
title: "CSRF (Cross-Site Request Forgery)"
draft: false
weight: 999
---

Cross-Site Request Forgery (CSRF) vulnerability causes problems where critical actions can be executed due to unintentional requests from users.
If this vulnerability is exploited, unintended purchases on shopping sites, changes to account information, or inappropriate message postings can be made without the user's consent.

## Attack Overview

CSRF attacks are typically carried out following these steps:

1. The user logs into the targeted site.
2. The user visits a fake site created by the attacker.
3. The fake site sends an unintentional request to the targeted site.

In CSRF attacks, the difference from Cross-Site Scripting (XSS) attacks is that existing functionalities within the target server are exploited.

## Mitigations

The main reason CSRF attacks occur is because systems are not verifying that requests are intentional and made by a legitimate user.

While certain pages such as product detail pages on shopping sites should be accessible by anyone, special precautions need to be taken on pages where critical actions like purchase processes or personal information changes are performed.

### Use of CSRF Mitigation Tokens

Tokens are embedded in pages that submit forms, and sent via POST requests to be verified on the server side.
Unless users are tricked into pressing buttons via techniques like clickjacking, it won't be possible to send the correct token, thereby confirming that the access is not legitimate.

For example, when examining the form on GitLab.com's login screen, we can see the following tag with a hidden attribute and a token stored in its value.

```html
<input type="hidden" name="authenticity_token" value="xxxxxxxxxx" autocomplete="off">
```

By the way, clickjacking is an attack where users are tricked into pressing buttons by overlaying important action confirmation buttons and dummy links, but countermeasures in browsers are improving.

### Request Password Re-entry

By requesting users to re-enter their passwords before executing crucial actions, we can verify that the operation is indeed being performed by the user themselves.

### Verify Referer

The URL of the request's origin (Referer) is checked to detect requests coming from fraudulent pages.

### Use of Two-Factor Authentication

While two-factor authentication can't be said to directly prevent CSRF, it does enable early detection and minimizes damage if personal information has been updated unintentionally.

## References

- 徳丸 浩、「体系的に学ぶ 安全なWebアプリケーションの作り方 第2版」
