if (window.attachEvent) {
    window.attachEvent('onload', displayError);
} else {
    if (window.onload) {
        var curronload = window.onload;
        var newonload = function(evt) {
            curronload(evt);
            yourFunctionName(evt);
        };
        window.onload = newonload;
    } else {
        window.onload = displayError;
    }
}
function getParameterByName(name, url) {
    if (!url) {
      url = window.location.href;
    }
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
			   results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}

function displayError() {
    uri=getParameterByName('uri', window.location.href);
    if (uri) {
        document.getElementById("error").testContent = "You were logged out of "+uri;
    }
}
