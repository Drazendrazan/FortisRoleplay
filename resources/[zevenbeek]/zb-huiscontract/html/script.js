window.addEventListener('message', function(event) {
    if (event.data.type == "openVerkoper") {
        var kenteken = event.data.kenteken;
        var bedrag = false;
        openContract(kenteken, bedrag, true);

    } else if (event.data.type == "openKopen") {
        var kenteken = event.data.kenteken;
        var bedrag = event.data.bedrag;
        openContract(kenteken, bedrag, false)
    }
});


function openContract(kenteken, bedrag, verkoper) {
    var kenteken = kenteken;
    var bedrag = bedrag;
    var verkoper = verkoper;
    
    if (verkoper == true) {
        document.getElementById("bedragVeld").disabled = false;
        var kentekenVeld = document.getElementById("kentekenText");
        document.getElementById("bedragVeld").value = "";
        kentekenVeld.innerText = kenteken;

        $("body").fadeIn("slow");
    } else {
        var kentekenVeld = document.getElementById("kentekenText");
        kentekenVeld.innerText = kenteken;

        document.getElementById("bedragVeld").value = bedrag;

        document.getElementById("bedragVeld").setAttribute("disabled", true);
        $("body").fadeIn("slow");
    }
}

function overhandig() {
    var bedrag = document.getElementById("bedragVeld").value;
    var kenteken = document.getElementById("kentekenText").innerText;

    if(bedrag > 0 ) {
        if (bedrag <= 1000000) {
            bedrag = parseFloat(bedrag).toFixed(0)
            $.post("https://zb-huiscontract/plaatsContract", JSON.stringify({ 
                bedrag: bedrag,
                kenteken: kenteken,
            }));
            $("body").fadeOut("slow");
        } else {
            $("#error").fadeIn("slow").delay(4000).fadeOut("slow");
        }
    } else {
        $("#error").fadeIn("slow").delay(4000).fadeOut("slow");
    }
}

function annuleer() {
    $("body").fadeOut("slow");
    $.post("https://zb-huiscontract/annuleer", JSON.stringify({}));
}