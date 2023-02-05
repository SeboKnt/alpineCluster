//LOGIN FUNKTION FÜR ROOT
const loginForm = document.getElementById("login-form");
const loginButton = document.getElementById("login-form-submit");

loginButton.addEventListener("click", (e) => {
    e.preventDefault();
    const username = loginForm.username.value;
    const password = loginForm.password.value;

    if (username === "root" && password === "root") {
        alert("Sie haben sich erfolgreich angemeldet!");
        window.location = "success.html";
        return false;
    } else {
        alert("Anmeldung fehlgeschlagen!")
        window.location = "index.html";
        return false;
    }
})