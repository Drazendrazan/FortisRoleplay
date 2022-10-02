
window.addEventListener("message", function(event) {
    if (event.data.action == "OpenVoltageKast") {
        frame.OpenVoltageKast()
        timer(); 
    }
});

// On keypress Escape window closes
$(document).on('keydown', function(event) {
    switch(event.keyCode) {
        case 27: 
            frame.VerlaatKast();
        break;
    }
});

var Timer = null; 

function timer(){
    var sec = 10;
    Timer = setInterval(function(){
        const timer = $(".timer"); 
        timer.html(sec); 
        sec--;

        if (sec < 0) {
            clearInterval(Timer);
            frame.KastFailed(); 
        }
    }, 1000);
}
 

const app = {
    
    data() {
        return {
            show: false,
            knoppen: false,
            timer: false, 
            close: false, 

            stage6: false, 
            stage5: false, 
            stage4: false, 
            stage3: false,
            stage2: false,
            stage1: false,
        }
    },

    // Methods
    methods: {
        // Knoppen
        OpenVoltageKast() {
            this.show = true;
            this.knoppen = true;
            this.timer = true; 
            

            this.stage1 = true;
            this.stage2 = false;
            this.stage3 = false;
            this.stage4 = false;
            this.stage5 = false;
            this.stage6 = false;
            this.stage7 = false;

            this.disabled1 = false;
            this.disabled2 = false;
            this.disabled3 = false;
            this.disabled4 = false;
            this.disabled5 = false;
            this.disabled6 = false;
        },

        stage(aantal) {
            if (aantal == 1 && !this.disabled1) {
                console.log(1); 
                this.disabled1 = true;
                this.stage1 = false;
                this.stage3 = true; 
            } else if (aantal == 2 && !this.disabled2) {
                console.log(2); 
                this.disabled2 = true;
                this.stage2 = false;
                this.stage5 = true;
            } else if (aantal == 3 && !this.disabled3)  {
                console.log(3); 
                this.disabled3 = true;
                this.stage3 = false;
                this.stage2 = true;
            } else if (aantal == 4 && !this.disabled4)  {
                console.log(4); 
                this.disabled4 = true;
                this.stage4 = false;
                this.stage6 = true;
            } else if (aantal == 5 && !this.disabled5)  {
                console.log(5); 
                this.disabled5 = true;
                this.stage5 = false;
                this.stage4 = true;
            } else if (aantal == 6 && !this.disabled6) {
                console.log(6); 
                this.disabled6 = true;
                this.stage6 = false;
                this.stage7 = true; 
            }

            if (this.stage7) {
                setTimeout(() => {
                    this.stage6 = false;
                    this.knoppen = false;
                    this.show = false;
                    this.timer = false; 
                    clearInterval(Timer);
                    $.post("https://zb-lifeinvader/Succesvol", JSON.stringify({}));
                }, 1000);
            }
        },

        VerlaatKast() {
            this.show = false;
            this.knoppen = false;
            this.timer = false; 

            this.stage6 = false, 
            this.stage5 = false, 
            this.stage4 = false, 
            this.stage3 = false,
            this.stage2 = false,
            this.stage1 = false,

            $.post("https://zb-lifeinvader/verlaat", JSON.stringify({})); 
        }, 

        KastFailed() {
            this.show = false;
            this.knoppen = false;
            this.timer = false; 

            this.stage6 = false, 
            this.stage5 = false, 
            this.stage4 = false, 
            this.stage3 = false,
            this.stage2 = false,
            this.stage1 = false

            $.post("https://zb-lifeinvader/failed", JSON.stringify({}));
        }
    }
}

var frame = Vue.createApp(app).mount("#app");