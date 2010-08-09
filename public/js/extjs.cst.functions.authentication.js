/* ExtJs Custom Functions for Authentication */

// Login
// usage: fnc_login
function fnc_login(varForm, varWindow) {
    fnc_submit_form(
        varForm,
        function (form) {
            fnc_redirect(fnc_url('/'), varWindow, 'Login Successful, Please Wait...');
        }
    );
}