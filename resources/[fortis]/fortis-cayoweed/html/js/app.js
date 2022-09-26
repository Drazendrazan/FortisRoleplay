window.addEventListener("message", function(event) {
    if (event.data.type == "pluk") {
        frame.startPluk()
    }
    else if (event.data.type == "verpak") {
        frame.startVerpak();
    }
});


const app = {
    data() {
        return {
            show: false,

            plukken1: false,
            plukken2: false,

            verpakken: false,
            verpakWietje: false,
            zippen: false,
            zipValue: 0,
            zipStartTijd: 0,

            stage3: false,
            stage2: false,
            stage1: false,

            wietPlekjeVerpak: "0%"
        }
    },

    // Methods

    methods: {
        //  Plukken
        startPluk() {
            if (Math.floor(Math.random() * 2) + 1 == 1) {
                this.show = true;
                this.plukken1 = true;

                this.stage1 = true;
                this.stage2 = false;
                this.stage3 = false;
                this.stage4 = false;

                this.disabled1 = false;
                this.disabled2 = false;
                this.disabled3 = false;
            } else {
                this.show = true;
                this.plukken2 = true;

                this.stage1 = true;
                this.stage2 = false;
                this.stage3 = false;
                this.stage4 = false;

                this.disabled1 = false;
                this.disabled2 = false;
                this.disabled3 = false;
            }
        },
        stage(aantal) {
            var pop = document.getElementById("popgeluidje");
            document.getElementById("popgeluidje").volume = 0.2;
            // var pop = new Audio("pop.mp3");
            if (aantal == 1 && !this.disabled1) {
                this.disabled1 = true;
                pop.play();
                this.stage1 = false;
                this.stage2 = true;
            } else if (aantal == 2 && !this.disabled2) {
                this.disabled2 = true;
                pop.play();
                this.stage2 = false;
                this.stage3 = true;
            } else if (aantal == 3 && !this.disabled3)  {
                // Laatste
                this.disabled3 = true;
                pop.play();
                this.stage3 = false;
                this.stage4 = true;
                setTimeout(() => {
                    this.stage4 = false;
                    this.plukken1 =false;
                    this.plukken2 = false;
                    this.show = false;
                    $.post("http://fortis-cayoweed/plukGeslaagd", JSON.stringify({}));
                }, 1000);
            }
        },





        // Verpakken
        startVerpak() {
            var randomsLeftjes = ["100%", "-100%", "0%"];
            var randomGetalletje = Math.floor(Math.random() * 3);
            this.wietPlekjeVerpak = randomsLeftjes[randomGetalletje];

            this.show = true;
            this.verpakken = true;
        },

        verpakHetWietje() {
            this.verpakWietje = true;
            this.wietPlekjeVerpak = "0%";
        },

        kaas() {
            if (this.zipValue == 100) {
                var tijdNu = Date.now();
                if (tijdNu >= this.zipStartTijd + 1300) {
                    this.verpakken = false,
                    this.show = false,
                    this.zipValue = 0;
                    this.verpakWietje = false;
                    this.zipStartTijd = 0;
                    $.post("http://fortis-cayoweed/verpakGeslaagd", JSON.stringify({}));
                } else {
                    this.verpakken = false,
                    this.show = false,
                    this.zipValue = 0;
                    this.verpakWietje = false;
                    this.zipStartTijd = 0;
                    $.post("http://fortis-cayoweed/verpakGefaald", JSON.stringify({
                        reden: 1
                    }));
                }
            }
        },

        zipStartie() {
            if (this.zipStartTijd == 0) {
                this.zipStartTijd = Date.now();
            } else {
                this.verpakken = false,
                this.show = false,
                this.zipValue = 0;
                this.verpakWietje = false;
                this.zipStartTijd = 0;
                $.post("http://fortis-cayoweed/verpakGefaald", JSON.stringify({
                    reden: 2
                }));
            }
        },

        // Als hij naast het frame clickt, vieze gore vuile vakbond lijer
        hahaGefaaldFaggot() {
            this.verpakken = false,
            this.show = false,
            this.zipValue = 0;
            this.verpakWietje = false;
            this.zipStartTijd = 0;
            $.post("http://fortis-cayoweed/verpakGefaald", JSON.stringify({
                reden: 2
            }));
        }

    }
}


var frame = Vue.createApp(app).mount("#app");
