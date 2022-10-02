QBTuner = {}

var headlightVal = 0;
var RainbowNeon = false;
var RainbowHeadlight = false;

$(document).ready(function(){
    $('.container').hide();

    window.addEventListener('message', function(event){
        var eventData = event.data;

        if (eventData.action == "ui") {
            if (eventData.toggle) {
                QBTuneropenen()
            }
        }
    });
});

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27:
            QBTunerSluiten();
            break;
    }
});


$(document).on('click', '#cancel', function(){
    QBTunerSluiten();
});

$(document).on('click', "#neon", function(){
    $(".tunerchip-block").css("display", "none");
    $(".headlights-block").css("display", "none");
    $(".stancer-block").css("display", "none");
    $(".neon-block").css("display", "block");
})

$(document).on('click', "#save-neon", function(){
    if (RainbowNeon) {
        $.post('https://zb-tunerchip/saveNeon', JSON.stringify({
            neonEnabled: $("#neon-slider").val(),
            r: $("#color-r").val(),
            g: $("#color-g").val(),
            b: $("#color-b").val(),
            rainbowEnabled: true,
        }));
    } else {
        $.post('https://zb-tunerchip/saveNeon', JSON.stringify({
            neonEnabled: $("#neon-slider").val(),
            r: $("#color-r").val(),
            g: $("#color-g").val(),
            b: $("#color-b").val(),
            rainbowEnabled: false,
        }));
    }
})


$(document).on('click', ".neon-software-color-pallete-color", function(){
    var headlightValue = $(this).data('value');

    if (headlightValue === "rainbow") {
        RainbowHeadlight = true;
    } else {
        RainbowHeadlight = false;
    }

    if (!$(this).data('rainbow')) {
        var r = $(this).data('r')
        var g = $(this).data('g')
        var b = $(this).data('b')
    
        $("#color-r").val(r) 
        $("#color-g").val(g)
        $("#color-b").val(b) 
    
    
        if (headlightValue != null) {
            headlightVal = headlightValue
            var colorValue = $(this).css("background-color");
            $(".neon-software-color-pallete-color-current").css("background-color", colorValue);
        }
        RainbowNeon = false;
    } else {
        RainbowNeon = true;
    }
});

QBTuneropenen = function() {
    $.post('https://zb-tunerchip/checkItem', JSON.stringify({item: "tunerlaptop"}), function(hasItem){
        if (hasItem) {
            $('.container').fadeIn(250);
        }
    })
}

QBTunerSluiten = function() {
    $('.container').fadeOut(250);
    $.post('https://zb-tunerchip/exit');
}