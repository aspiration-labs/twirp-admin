
let authServer = "";
let aspirationEncodedClient = "";

function handleAuthSuccess(authData) {
    let token = "";
    let refreshToken = "";

    if (authData.token !== undefined) {
        token = authData.token;
        refreshToken = authData.refreshToken;
        const credentialDetail = '<details><summary>' + authData.adminUser.role + '</summary>'
            + '<pre>' + JSON.stringify(authData.adminUser, null, 4) + '</pre>'
            + '</details>';
        $('#credentials-display').append(credentialDetail);
    } else if (authData.access_token !== undefined) {
        token = authData.access_token;
        refreshToken = authData.refresh_token;
        $('#credentials-display').remove();
        const banner = '<div id="credentials-display" style="float: right; width: 30%">Login succeeded</div>';
        $('#token-credentials').append(banner);
    } else {
        $('#credentials-display').remove();
        const banner = '<div id="credentials-display" style="float: right; width: 30%">Login failed</div>';
        $('#token-credentials').append(banner);
    }

    console.log(token);
    $('#aspiration_auth_token').val(token);
    $('#aspiration_refresh_token').val(refreshToken);
}

function setupSwaggerAuth(authServerUrl, googleOauthClientId, aspirationClientAndSecret) {
    authServer = authServerUrl;
    aspirationEncodedClient = btoa(aspirationClientAndSecret);

    hello.init({
        google: googleOauthClientId
    });

    hello.on('auth.login', function (auth) {

        let googleAuthToken = auth.authResponse.access_token;
        hello(auth.network).api('/me').then(function (resp) {
            const banner = '<div id="credentials-display" style="float: right; width: 30%">'
                + '<img src="' + resp.thumbnail + '" style="max-height: 50px;"/> Hey ' + resp.name + '</div>';
            $('#credentials-display').remove();
            $('#token-credentials').append(banner);
            if (window.location.href.endsWith('?auth-google')) {
                    window.location.assign('/docs/');
            }
            $.ajax({
                url: authServer + '/oauth/google',
                type: 'post',
                data: googleAuthToken,
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                success: handleAuthSuccess,
                error: function (xhr, textStatus, errorMessage) {
                    console.log("\nYou may need a browser extension that modifies CORS response to your browser to access this feature in development."
                                + "\n\nhttps://chrome.google.com/webstore/detail/moesif-orign-cors-changer/digfbfaphojjndkpccljibejjbppifbc has been tested for this purpose."
                                + "\n\nUse this extension carefully and turn off when not needed");
                    alert("Authserver /oauth/google token exchange failed. See console log for details.");
                }
            });
        });
    });

    // remove the greeting when we log out

    hello.on('auth.logout', function () {
        $('#credentials-display').remove();
    });
}

function googleLogin() {
    window.location.assign('/docs/?auth-google');
}

function deferredGoogleLogin() {
    if (window.location.href.endsWith('?auth-google')) {
        hello('google').login({scope: 'email'});
    }
}

function googleLogout() {
    hello('google').logout();
}

function aspirationLogin() {
    const username = $('#input_username').val();
    const password = $('#input_password').val();
    const data = {
        'username': username,
        'password': password
    };
    $.ajax({
        url: authServer + '/oauth/token?scope=read&grant_type=password',
        type: 'post',
        data: data,
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Authorization': 'Basic ' + aspirationEncodedClient
        },
        success: handleAuthSuccess,
        error: function (xhr, textStatus, errorMessage) {
        }
    });
}
