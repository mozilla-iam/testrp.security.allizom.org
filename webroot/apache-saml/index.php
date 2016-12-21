<?php
    date_default_timezone_set('UTC');
?>
<!DOCTYPE html>
<html>
    <head>
        <title>Apache SAML RP</title>
        <meta charset="utf-8">
        <link rel="stylesheet" href="/media/css/sandstone.css" media="all">
    </head>
    <body class="sand">
        <div id="outer-wrapper">
          <div id="wrapper">
            <header id="masthead">
              <h1>Apache SAML RP</h1>
            </header>
          </div>
        </div>
        <div id="main-content">
            <h1>Authentication status</h1>
<?php
                echo "Logged in as: ".$_SERVER['REMOTE_USER'].", also known as ".$_SERVER['GIVEN_NAME']." ";
?>
            (<a href="/mellon/logout?ReturnTo=https://testrp.security.allizom.org/">Logout (from Auth0 and this site)</a>) (<a href="https://testrp.security.allizom.org">Go back to testrp.security.allizom.org / main page</a>)<br/>
            <br/>
            <br/>

            <p>
            This test setup and complete configuration can be found at: <a href="https://github.com/mozilla-iam/testrp.security.allizom.org">https://github.com/mozilla-iam/testrp.security.allizom.org</a>
            </p>

            <h2>Headers</h2>
            <pre>
<?php
            foreach($_SERVER as $key => $value) {
                    if (substr($key, 0, 7) === "MELLON_") {
                        echo $key.":".$value."<br/>";
                    }
            }
?>
            </pre>
        </div>
    </body>
</html>
