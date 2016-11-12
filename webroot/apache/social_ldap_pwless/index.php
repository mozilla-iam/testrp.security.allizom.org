<?php
    date_default_timezone_set('UTC');
?>
<!DOCTYPE html>
<html>
    <head>
        <title>Apache OpenID Connect RP</title>
        <meta charset="utf-8">
        <link rel="stylesheet" href="/media/css/sandstone.css" media="all">
    </head>
    <body class="sand">
        <div id="outer-wrapper">
          <div id="wrapper">
            <header id="masthead">
              <h1>Apache OpenID Connect RP</h1>
            </header>
          </div>
        </div>
        <div id="main-content">
            <h1>Authentication status</h1>
<?php
                echo "Logged in as: ".$_SERVER['HTTP_REMOTE_USER'].", also known as ".$_SERVER['HTTP_OIDC_CLAIM_ID_TOKEN_NAME']." ";
?>
            (<a href="/logout">Logout</a>)<br/>
            Your id_token (and session) will expire on: <?php echo date("d F Y H:i:s", $_SERVER['HTTP_OIDC_CLAIM_ID_TOKEN_EXP']); ?> UTC
            </br>
            </br>

            <p>
            This test setup and complete configuration can be found at: <a href="https://github.com/mozilla-iam/testrp.security.allizom.org">https://github.com/mozilla-iam/testrp.security.allizom.org</a>
            </p>

            <h2>Headers</h2>
            <pre>
<?php
            foreach($_SERVER as $key => $value) {
                    if (substr($key, 0, 5) === "HTTP_") {
                        echo $key.":".$value."</br>";
                    }
            }
?>
            </pre>

            <h2>Endpoints</h2>

            <h3>userinfo</h3>
            <a href="https://auth-dev.mozilla.auth0.com/userinfo?access_token=<?php echo $_SERVER['HTTP_OIDC_CLAIM_ACCESS_TOKEN'];?>">https://auth-dev.mozilla.auth0.com/userinfo?access_token=<?php echo $_SERVER['HTTP_OIDC_CLAIM_ACCESS_TOKEN'];?></a>

            <h3>tokeninfo</h3>
            <a href="https://auth-dev.mozilla.auth0.com/tokeninfo?id_token=<?php echo $_SERVER['HTTP_OIDC_CLAIM_ID_TOKEN'];?>">https://auth-dev.mozilla.auth0.com/tokeninfo?id_token=<?php echo $_SERVER['HTTP_OIDC_CLAIM_ID_TOKEN'];?></a>
        </div>
    </body>
</html>
