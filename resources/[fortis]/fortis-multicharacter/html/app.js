// Copyright Finn#0007 - 2021

window.addEventListener("message", function(event) {
    if (event.data.type == "hide") {
        frame.show(false);
    } else if (event.data.type == "sendKarakters") {
        frame.insertKarakters(event.data.karakters);
    } else if (event.data.type == "karakterReadySelected") {
        frame.karakterReadySelected();
    } else if (event.data.type == "showLaadscherm") {
        frame.showLaadscherm();
    }
});

const app = {
    data() {
        return {
            showLaden: false,
            showMenu: false,
            magSelecteren: true,
            selected: 0,

            verwijderen: false,
            verwijderenKarakterInfo: null,
            verwijderBtnDisabled: true,
            verwijderText: "Verwijderen",

            maaktKarakter: false,
            nieuwKarakterInfo: {
                cid: 0,
                voornaam: "",
                achternaam: "",
                dag: "",
                maand: "",
                jaar: "",
                nationaliteit: "Nederlands",
                geslacht: ""
            },

            karakters: {
                [1]: {},
                [2]: {},
                [3]: {},
                [4]: {},
                [5]: {},
            },

            // Data tegen dubbele kliks
            pressedSpeel: false,
            pressedMaak: false,
            pressedVerwijderFull: false
        }
    },

    methods: {
        // Laat het karakter scherm NUI zien, wordt getriggerd wanneer het laadscherm klaar is
        show(visible) {
            if (visible) {
                this.showLaden = false;
                this.showMenu = true;
            } else {
                this.showLaden = false;
                this.showMenu = false;
            }
        },
        showLaadscherm() {
            this.showLaden = true;
        },
        // Zet de karakters in de data
        insertKarakters(chars) {
            this.karakters[1] = chars[0];
            this.karakters[2] = chars[1];
            this.karakters[3] = chars[2];
            this.karakters[4] = chars[3];
            this.karakters[5] = chars[4];
            
            if (typeof(this.karakters[1]) != "undefined") {this.karakters[1]["selected"] = false;}
            if (typeof(this.karakters[2]) != "undefined") {this.karakters[2]["selected"] = false;}
            if (typeof(this.karakters[3]) != "undefined") {this.karakters[3]["selected"] = false;}
            if (typeof(this.karakters[4]) != "undefined") {this.karakters[4]["selected"] = false;}
            if (typeof(this.karakters[5]) != "undefined") {this.karakters[5]["selected"] = false;}
            this.show(true);
        },


        // [Start van echte functies]
        selecteerKarakter(index) {
            this.selected = index;
            for (const [key] of Object.entries(this.karakters)) {
                if (typeof(this.karakters[key]) != "undefined") {
                    if(this.karakters[key].selected == true && key == index) {
                        return;
                    }
                    this.karakters[key].selected = false;
                }
            }
            this.magSelecteren = false;
            $.post("http://fortis-multicharacter/selectKarakter", JSON.stringify({
                citizenid: this.karakters[index].citizenid
            }));
        },

        karakterReadySelected() {
            this.magSelecteren = true;
            this.karakters[this.selected].selected = true;
        },

        nieuwKarakter() {
            this.nieuwKarakterInfo["voornaam"] = "";
            this.nieuwKarakterInfo["achternaam"] = "";
            this.nieuwKarakterInfo["dag"] = "";
            this.nieuwKarakterInfo["maand"] = "";
            this.nieuwKarakterInfo["jaar"] = "";
            this.nieuwKarakterInfo["nationaliteit"] = "Nederlands";
            this.nieuwKarakterInfo["geslacht"] = "";
            this.maaktKarakter = true;
        },

        sluitMaakKarakter() {
            this.maaktKarakter = false;
        },

        veranderGeslacht(geslacht) {
            this.nieuwKarakterInfo["geslacht"] = geslacht;

            $("#geslacht-man").removeClass("geslacht-selected");
            $("#geslacht-vrouw").removeClass("geslacht-selected");

            $("#geslacht-" + geslacht).addClass("geslacht-selected");
        },

        maakKarakter() {
            if (this.nieuwKarakterInfo["voornaam"] != "" && this.nieuwKarakterInfo["achternaam"] != "" && this.nieuwKarakterInfo["dag"] != "" && this.nieuwKarakterInfo["maand"] != "" && this.nieuwKarakterInfo["jaar"] != "" && this.nieuwKarakterInfo["nationaliteit"] != "" && this.nieuwKarakterInfo["geslacht"] != "") {
                if (this.pressedMaak) { return; }
                this.pressedMaak = true;
                $.post("http://fortis-multicharacter/maakNieuwKarakter", JSON.stringify({
                    data: this.nieuwKarakterInfo
                }));
                this.showMenu = false;
                setTimeout(() => {
                    this.pressedMaak = false;
                }, 5000);
            } else {
                Swal.fire({
                    title: 'Fout!',
                    text: 'Een of meerdere velden zijn niet ingevuld of aangeklikt!',
                    icon: 'error',
                    confirmButtonText: 'OK'
                });
            }
        },

        speelKarakter(karakter) { // Speel knop
            if (this.pressedSpeel) { return; }
            this.pressedSpeel = true;
            $.post("http://fortis-multicharacter/speelKarakter", JSON.stringify({
                data: karakter
            }));
            setTimeout(() => {
                this.pressedSpeel = false;
            }, 15000);
        },

        verwijderKarakter(karakter) { // Verwijder knop bij char, nog niet full verwijder, eerst aftellen
            // Ja ik weet dat dit super slecht gemaakt is lmao, maar het doet preciesss wat ik wil :)
            this.verwijderBtnDisabled = true;
            this.verwijderText = "Verwijderen (5)";
            this.verwijderen = true;
            this.verwijderenKarakterInfo = karakter;
            
            setTimeout(() => {
                if(!this.verwijderen) {return;}
                this.verwijderText = "Verwijderen (4)";
                setTimeout(() => {
                    if(!this.verwijderen) {return;}
                    this.verwijderText = "Verwijderen (3)";
                    setTimeout(() => {
                        if(!this.verwijderen) {return;}
                        this.verwijderText = "Verwijderen (2)";
                        setTimeout(() => {
                            if(!this.verwijderen) {return;}
                            this.verwijderText = "Verwijderen (1)";
                            setTimeout(() => {
                                if(!this.verwijderen) {return;}
                                this.verwijderText = "Verwijderen";
                                this.verwijderBtnDisabled = false;
                            }, 1000);
                        }, 1000);
                    }, 1000);
                }, 1000);
            }, 1000);
            
        },

        verwijderKarakterDefinitief() { // De volledige verwijder functie, na het aftellen
            if (this.pressedVerwijderFull) { return; }
            this.pressedVerwijderFull = true;
            this.showMenu = false;
            this.showLaden = true;
            $.post("http://fortis-multicharacter/verwijderKarakter", JSON.stringify({
                data: this.verwijderenKarakterInfo
            }));
            this.verwijderenKarakterInfo = null;
            this.verwijderen = false;

            setTimeout(() => {
                this.pressedVerwijderFull = false;
            }, 3500);
        },

        sluitVerwijderKarakter() {
            this.verwijderenKarakterInfo = null;
            this.verwijderen = false;
        }
    },
}

var frame = Vue.createApp(app).mount("#app");
