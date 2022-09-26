window.addEventListener('message', function(event){
    if (event.data.type == "openLaptop") {
        frame.openLaptop(event.data.syncOnly, event.data.handelAppData, event.data.groothandelData, event.data.werknemersData, event.data.specialisatieData);
    } else if (event.data.type == "syncHandelApp") {
        frame.syncHandelApp(event.data.handelAppData);
    } else if (event.data.type == "ontslagenQuit") {
        frame.closeLaptop();
    }
});

const app = {
    data() {
        return {
            "showLaptop": false,
            "menuTijd" : "00:00",
            "activeApp": "",
            "appleMenuActive": false,
            "tijdTotNieuweLijst": "00:00",
            "groothandelData" : null,
            "werknemersData": null,
            "specialisatie_timer": "Laden...",
            "specialisatie_aanpassen_kan": false,
            "specialisatieData": null,

            "programmas": {
                "magazijn": {
                    "name": "Magazijn",
                    "open": false,
                    "fullscreen": false,
                    "appData": {
                        "bsn": "",
                        "werknemer_error": ""
                    }
                },
                "fortis_markt": {
                    "name": "Fortis markt",
                    "open": false,
                    "fullscreen": false
                },
                "handel": {
                    "name": "Handel",
                    "open": false,
                    "fullscreen": false,
                    "appData": null,
                    "options": {
                        "screen": "keuze"
                    }
                }
            }
        }
    },

    methods: {
        // Laptop openen
        openLaptop(syncOnly, tmp_handel_data, tmp_groothandel_data, tmp_werknemers_data, specialisatieData) {
            this.programmas.handel.appData = JSON.parse(tmp_handel_data);
            this.groothandelData = JSON.parse(tmp_groothandel_data);
            this.werknemersData = JSON.parse(tmp_werknemers_data);
            this.specialisatieData = JSON.parse(specialisatieData);
            if (!syncOnly) {
                // Dit is niet alleen een sync, maar daadwerkelijk het openen van de laptop
                this.showLaptop = true;
            }
        },

        // Laptop sluiten
        closeLaptop() {
            this.showLaptop = false;
            this.appleMenuActive = false;
            $.post("https://fortis-groothandel/sluitLaptop", JSON.stringify({}));
        },

        syncHandelApp(tmp_handel_data) {
            this.programmas.handel.appData = JSON.parse(tmp_handel_data);
        },

        // Open app
        openApp(app_name) {
            this.programmas[app_name].open = !this.programmas[app_name].open;
            this.activeApp = app_name;
            setTimeout(() => {
                dragElement(document.getElementById(app_name));
            }, 500);
        },

        // Programma sluiten OF minimizen, same shit
        closeApp(app_name) {
            this.programmas[app_name].open = false;
        },

        // Programma fullscreen maken, hepl
        fullscreenApp(app_name) {
            var element = document.getElementById(app_name);
            if (!this.programmas[app_name].fullscreen) {
                element.style.position = "sticky";
                element.style.width = "99%";
                element.style.height = "80%";
                element.style.display = "block";
                element.style.margin = "3px auto 3px auto";
                element.style.top = "0px";
                element.style.left = "0px";
            } else {
                element.style.position = "absolute";
                element.style.width = "800px";
                element.style.height = "500px";
                element.style.margin = "0px";
                element.style.top = "80px";
                element.style.left = "50px";
            }
            this.programmas[app_name].fullscreen = !this.programmas[app_name].fullscreen;
        },

        // Muis klik
        mouseClick() {
            document.getElementById("audioding").volume = 0.5;
            document.getElementById("audioding").play();
        },

        // Werknemer aannemen knop binnen MAGAZIJN app
        werknemerAannemen() {
            if (this.programmas.magazijn.appData.bsn && this.programmas.magazijn.appData.bsn.length > 0) {
                if (this.groothandelData.data.werknemerspots > Object.keys(this.werknemersData).length) {
                    // Stuur post request
                    $.post("https://fortis-groothandel/werknemerAannemen", JSON.stringify({
                        bsn: this.programmas.magazijn.appData.bsn
                    }), function(resultaat) {
                        if (resultaat.resultaat) {
                            $.post("https://fortis-groothandel/NuiNotify", JSON.stringify({
                                msg: resultaat.bericht,
                                type: "success",
                                time: 4500
                            }));
                        } else {
                            $.post("https://fortis-groothandel/NuiNotify", JSON.stringify({
                                msg: resultaat.bericht,
                                type: "error",
                                time: 6500
                            }));
                        }
                    });

                } else {
                    this.programmas.magazijn.appData.werknemer_error = "Je hebt geen werknemer plekken over, koop ze bij!";
                    setTimeout(() => {
                        if (this.programmas.magazijn.appData.werknemer_error == "Je hebt geen werknemer plekken over, koop ze bij!") {
                            this.programmas.magazijn.appData.werknemer_error = "";
                        }
                    }, 5000);
                }
                this.programmas.magazijn.appData.bsn = "";
            } else {
                this.programmas.magazijn.appData.werknemer_error = "Vul het burgerservicenummer in!";
                setTimeout(() => {
                    if (this.programmas.magazijn.appData.werknemer_error == "Vul het burgerservicenummer in!") {
                        this.programmas.magazijn.appData.werknemer_error = "";
                    }
                }, 5000);
            }
        },

        // Werknemer ontslaan als eigenaar via mijn magazijn app
        werknemerOntslaan(citizenid) {
            $.post("https://fortis-groothandel/werknemerOntslaan", JSON.stringify({
                cid: citizenid
            }))
        },

        // Werknemer slot bijkopen
        koopWerknemerSlot() {
            if (this.groothandelData.data.werknemerspots < 5) {
                $.post("https://fortis-groothandel/koopWerknemerSlot", JSON.stringify({}));
            }
        },

        // Start handel ronde (verkopen en inkopen in 1 functie)
        handel_start(type, index) {
            $.post("https://fortis-groothandel/startRonde", JSON.stringify({
                id: index,
                type: type
            }));
        },

        balansOpnemen() {
            $.post("https://fortis-groothandel/balansOpnemen", JSON.stringify({}));
        },

        koopVoertuig(voertuig) {
            $.post("https://fortis-groothandel/koopVoertuig", JSON.stringify({
                voertuig: voertuig,
            }));
        },

        heeftSpecialisatie(spec_id) {
            var heeft = false;
            this.groothandelData.data.specialisaties.forEach(element => {
                if (element == spec_id) {
                    heeft = true;
                }
            });
            return heeft;
        },

        veranderSpecialisatie() {
            if (this.groothandelData.data.specialisatie_aanpassen_kan) {
                this.groothandelData.data.specialisatie_aanpassen_kan = false;
                this.groothandelData.data.specialisatie_timeout = 3130238139;
                $.post("https://fortis-groothandel/veranderSpecialisaties", JSON.stringify({}));
            } else {
                // Weet niet hoe je hier kan komen, tenzij je een smerige kaulo hacker bent maar alsnog pak ik je moeder aan, ik laat je KAULO moeder huilen vriend tabon yemek sikter git lan amanakoiyuifdjm yes bye
                $.post("https://fortis-groothandel/NuiNotify", JSON.stringify({
                    msg: "Je kan geen specialisatie aanpassen, wacht je tijd uit!",
                    type: "error",
                    time: 6500
                }));
            }
        },

        // Domme functies maar wel hella litty gang gnag je weet
        numberWithCommas(x) {
            return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".");
        }
    },

    created() {
        // IRL Tijd rechtsboven in laptop
        setInterval(() => {
            var dateObject = new Date();
            var minutes = dateObject.getMinutes();
            if (minutes < 10) {
                minutes = "0" + minutes;
            }
            this.menuTijd = dateObject.getHours() + ":" + minutes;
        }, 1000);

        // Tijd tot nieuwe lijst
        setInterval(() => {
            var dateObject = new Date();
            var minutes = 60 - dateObject.getMinutes();
            var seconds = 60 - dateObject.getSeconds();
            if (minutes < 10) {minutes = "0" + minutes;}
            if (seconds < 10) {seconds = "0" + seconds;}

            this.tijdTotNieuweLijst = minutes + ":" + seconds;
        }, 1000);

        // Interval voor nieuwe specialisaties
        setInterval(() => {
            if (this.groothandelData !== null && this.groothandelData.data.specialisatie_timeout !== null) {
                var d = new Date(0);
                d.setUTCSeconds(this.groothandelData.data.specialisatie_timeout);
                var date_now = new Date();

                var currentEPOCH = Math.round(date_now.getTime() / 1000)

                if (currentEPOCH >= this.groothandelData.data.specialisatie_timeout) {
                    // Yo bro sickie woekoe laat die goonie oenie specialisatie kiezen oulleh wapper
                    this.groothandelData.data.specialisatie_aanpassen_kan = true;
                } else {
                    // Je moeder, ga wachten
                    seconds = Math.floor((d - (date_now))/1000);
                    minutes = Math.floor(seconds/60);
                    hours = Math.floor(minutes/60);
                    days = Math.floor(hours/24);
                    hours = hours-(days*24);
                    minutes = minutes-(days*24*60)-(hours*60);
                    seconds = seconds-(days*24*60*60)-(hours*60*60)-(minutes*60);
                    // Formateren met 0 ervoor i.p.v. 9 seconden 09 seconden etc.
                    if (seconds < 10) { seconds = "0"+seconds; }
                    if (minutes < 10) { minutes = "0"+minutes; }
                    if (hours < 10) { hours = "0"+hours; }
                    if (days < 10) { days = "0"+days; }

                    this.groothandelData.data.specialisatie_aanpassen_kan = false;
                    // Zet tijd in string. WTF STRING? WEIRDO
                    this.specialisatie_timer = days + ":" + hours + ":" + minutes + ":" + seconds;
                }
            }
        }, 1000);
    }
}

var frame = Vue.createApp(app).mount("#app");



// Hele ratteplan voor programmas draggable maken
function dragElement(elmnt) {
    var pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;
    if (document.getElementById(elmnt.id + "-header")) {
        // if present, the header is where you move the DIV from:
        document.getElementById(elmnt.id + "-header").onmousedown = dragMouseDown;
    }

  function dragMouseDown(e) {
        e = e || window.event;
        e.preventDefault();
        // get the mouse cursor position at startup:
        pos3 = e.clientX;
        pos4 = e.clientY;
        document.onmouseup = closeDragElement;
        // call a function whenever the cursor moves:
        document.onmousemove = elementDrag;
    }

  function elementDrag(e) {
        e = e || window.event;
        e.preventDefault();
        // calculate the new cursor position:
        pos1 = pos3 - e.clientX;
        pos2 = pos4 - e.clientY;
        pos3 = e.clientX;
        pos4 = e.clientY;
        // set the element's new position:
        if (elmnt.offsetTop - pos2 >= 0 && elmnt.offsetLeft - pos1 >= 0) {
            if (elmnt.offsetTop >= (parentHeight(elmnt) - elmnt.clientHeight)) {
                elmnt.style.top = (elmnt.offsetTop - pos2) - 20 + "px";
                return;
            }
            if (elmnt.offsetLeft >= (parentWidth(elmnt) - elmnt.clientWidth)) {
                elmnt.style.left = (elmnt.offsetLeft - pos1) - 20 + "px";
                return;
            }

            elmnt.style.top = (elmnt.offsetTop - pos2) + "px";
            elmnt.style.left = (elmnt.offsetLeft - pos1) + "px";
        }
    }

  function closeDragElement() {
        // stop moving when mouse button is released:
        document.onmouseup = null;
        document.onmousemove = null;
    }

    function parentHeight(elem) {
        return elem.parentElement.clientHeight;
    }
    function parentWidth(elem) {
        return elem.parentElement.clientWidth;
    }
}