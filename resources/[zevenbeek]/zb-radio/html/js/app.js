// VUE
window.addEventListener("message", function (event) {
    if (event.data.type == "open") {
        $("#radio").slideDown(300);
    } else if (event.data.type == "updateLijst") {
        kaasje = JSON.parse(event.data.lijst)      ;
        frame.update(kaasje);
    } else if (event.data.type == "verbreek") {
        frame.verbonden = false;
        frame.verbondenGebruikers = null;
    }
});

document.onkeydown = function (evt) {
    evt = evt || window.event;
    if (evt.key == "Escape") {
        $("#radio").slideUp();
        $.post("https://zb-radio/sluit");
    }
};

function verbind() {
    var frequentie = document.getElementById("frequentie").value;
    var naam = document.getElementById("naam").value;

    if (frequentie >= 1 && frequentie <= 1000 && naam.length > 0 && naam != "" && naam != " " && naam != "\\" && /\S/.test(naam)) {
        $.post("https://zb-radio/verbind", JSON.stringify({
            frequentie: frequentie,
            naam: naam
        }));
    } else {
        $.post("https://zb-radio/ongeldig");
    }
}

function verbreek() {
    $.post("https://zb-radio/verbreek");
}

const app = {
    data() {
        return {
            verbonden: false,
            verbondenGebruikers: null,
        }
    },

    methods: {
        update(lijst) {
            this.verbonden = true;
            this.verbondenGebruikers = null;
            this.verbondenGebruikers = lijst;
        }
    }
}

var frame = Vue.createApp(app).mount("#app");