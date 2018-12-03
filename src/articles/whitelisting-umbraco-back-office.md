---
Title: IP Whitelisting the Umbraco back-office
Description: How to add an IIS rewrite rule within the `web.config` file that whitelists access to the Umbraco URL.
Type: Article
Date: 1/16/16
---

<article class="content">

# IP Whitelisting the Umbraco back-office

Often times, for security reasons, it is important to block public access to Umbraco and the Umbraco log-in page. 
One simple solution is to add an IIS rewrite rule within the `web.config` file that whitelists access to the Umbraco URL. 

In the following example, only requests originating from `192.168.0.2` and `192.168.0.3` will gain access to log in and view the
Umbraco back-office. 
<br/>
``` xml
<system.webServer>
    <rewrite>
      <rules>

        <!-- Restrict access to Umbraco -->
        <rule name="Restrict  Umbraco access" stopProcessing="true">
          <match url="umbraco(?!/api/)" />
          <conditions>
            <!-- add input patterns that match the IP address ensuring to escape the '.' character -->
            <add input="{REMOTE_ADDR}" pattern="192\.168\.0\.2" negate="true"/>
            <add input="{REMOTE_ADDR}" pattern="192\.168\.0\.3" negate="true"/>
          </conditions>
          <action type="CustomResponse" statusCode="403" statusReason="Forbidden" statusDescription="Site is not accessible" />
        </rule>

      </rules>
    </rewrite>
  </system.webServer>

```
</article>