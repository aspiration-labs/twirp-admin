<!-- HTML for static distribution bundle build -->
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta name="google-signin-client_id" content="115937885995-fs1d8l2uk7smo0ji7kabauavsn5vfm6t.apps.googleusercontent.com">
    <title>Swagger UI</title>
    <link rel="stylesheet" type="text/css" href="./swagger-ui.css" >
    <link rel="icon" type="image/png" href="./favicon-32x32.png" sizes="32x32" />
    <link rel="icon" type="image/png" href="./favicon-16x16.png" sizes="16x16" />
    <style>
      html
      {
        box-sizing: border-box;
        overflow: -moz-scrollbars-vertical;
        overflow-y: scroll;
      }

      *,
      *:before,
      *:after
      {
        box-sizing: inherit;
      }

      body
      {
        margin:0;
        background: #fafafa;
      }

      li {
        list-style-type: none;
      }

      li > a {
        display: inline-block;
        padding: 16px;
        width: 100%;
        background-color: #E9F6F0 !important;
        color: #000;
        text-decoration: none;
        font-size: 18px;
        margin-bottom: 12px;
        border: 1px solid #49cc90;
        border-radius: 4px;
      }

      li > a:hover {
        opacity: 0.9;
        background-color: #eee !important;
      }
      .version > a {
        color: white !important;
      }
      .version > a:hover {
        color: yellow !important;
      }
    </style>
  </head>

  <body>
    <div id="swagger-pre" class="swagger-ui">
      <section class="block col-12">
        <h2><a href="/docs/">{{$.Application}} application services</h2></a>
        <div id="token-credentials" class="auth-container">
          <input class="" placeholder="username" id="input_username" name="username" type="text" size="10">
          <input class="" placeholder="password" id="input_password" name="password" type="password" size="10">
          <input class="" id="aspiration_auth_token" name="aspiration_auth_token" type="hidden">
          <input class="" id="aspiration_refresh_token" name="aspiration_auth_token" type="hidden">
          <button id="input_authorize" onclick="aspirationLogin()">Aspiration login</button>
          <button onclick="googleLogin()">Google login</button>
          <button onclick="googleLogout()">Google logout</button>
        </div>
        <ul>
          {{range $i, $service := .Services}}
          <li><a href="/docs/?url=./rpc/{{$service}}/service.swagger.json"><b>{{$service}}</b> - rpc/{{$service}}/service.swagger.json</a></li>
          {{end}}
        </ul>
      </section>

    </div>

    <div id="swagger-ui"></div>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://apis.google.com/js/platform.js" async defer></script>
    <script src="./hello.all.min.js"> </script>
    <script src="./swagger-ui-bundle.js"> </script>
    <script src="./swagger-ui-standalone-preset.js"> </script>
    <script src="./swagger-auth.js"> </script>
    <script>
    window.onload = function() {
      // Begin Swagger UI call region
      const ui = SwaggerUIBundle({
        url: "",
        dom_id: '#swagger-ui',
        deepLinking: true,
        presets: [
          SwaggerUIBundle.presets.apis,
          SwaggerUIStandalonePreset
        ],
        plugins: [
          SwaggerUIBundle.plugins.DownloadUrl
        ],
        layout: "StandaloneLayout",
        requestInterceptor: function (request) {
          const token = $('#aspiration_auth_token').val();

          if (token && token.trim() !== "" ) {
            request.headers.Authorization = "Bearer " + token;
            return request;
          }
        },
        displayRequestDuration: true,
        onComplete: function() {
          let version = $(".information-container .version");
          if (version.length > 0) {
              version.html("<a href='{{$.CommitUrl}}' target='_blank'>{{$.Githash}}</a> ({{$.RepoStatus}})");
          }
        }
      })
      // End Swagger UI call region

      window.ui = ui

      setupSwaggerAuth("https://api.alpha.aspiration.com",
              "115937885995-26vt11dg20dms6ob3b11qjhrvri27cq9.apps.googleusercontent.com",
              "233668646673605:33b17e044ee6a4fa383f46ec6e28ea1d");
      deferredGoogleLogin();
    }
  </script>
  </body>
</html>
