/* ExtJs Custom Functions */

// Paths, Webroot, Etc
// usage:
function fnc_url(varRelUrl) {
    glb_webroot = glb_webroot.replace(/\/$/, '');
    varRelUrl = varRelUrl.replace(/^\//, '');
    return glb_webroot + "/" + varRelUrl;
}

// Redirects
// usage: fnc_redirect(winvar, 'http://...');
function fnc_redirect(varUrl, varWindow, varMessage) {
    if (!varMessage)
        varMessage = "Loading, Please Wait...";
    if (varWindow)
        varWindow.hide();
    var mask = new Ext.LoadMask(Ext.getBody(), {
        msg: varMessage,
        removeMask: true
    });
    mask.show();
    window.location.href = varUrl;
}

// Form Submissions
// usage: fnc_submit_form(formvar, fnc_redirect(winvar, 'http://...'));
function fnc_submit_form(varForm, varSuccessCallback) {
    varForm.getForm().submit({
        method: 'POST',
        waitTitle: 'Connecting',
        waitMsg: 'Sending Information...',
        success: function(form, action) {
            varSuccessCallback(form);
        },
        failure: function(form, action) {
            if (action.failureType == 'server') {
                obj = Ext.util.JSON.decode(action.response.responseText);
                Ext.Msg.alert('Processing Failure!', obj.error.reason);
            } else {
                Ext.Msg.alert('Warning!', 'Server is unreachable : ' + action.response.responseText);
            }
            form.reset();
        }
    });
};