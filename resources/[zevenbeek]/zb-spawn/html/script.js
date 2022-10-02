$(document).ready(function() {

    $(".container").hide();
    $("#submit-spawn").hide()

    window.addEventListener('message', function(event) {
        var data = event.data;
        if (data.type === "ui") {
            if (data.status == true) {
                $(".container").fadeIn(250);
				new1 = data.new
            } else {
                $(".container").fadeOut(250);
				new1 = data.new
            }
        }

        if (data.action == "setupLocations") {
            // setupLocations(data.locations, data.houses);
            // Sikter git
            // Sikter lan
            kaasje();
        }

        if (data.action == "setupAppartements") {
            setupApps(data.locations, data.new);
        }
    })
})

var currentLocation = null
new1 = null

$(document).on('click', '.location', function(evt){
    evt.preventDefault(); //dont do default anchor stuff
    var location = $(this).data('location'); //get the text
    var type = $(this).data('type'); //get the text
    var label = $(this).data('label'); //get the text
    if (type !== "lab") {
        $("#spawn-label").html("Bevestig")
        $("#submit-spawn").attr("data-location", location);
        $("#submit-spawn").attr("data-type", type);
        $("#submit-spawn").fadeIn(100)
        $.post('https://zb-spawn/setCam', JSON.stringify({
            posname: location,
            type: type,
        }));
        if (currentLocation !== null) {
            $(currentLocation).removeClass('selected');
        }
        $(this).addClass('selected');
        currentLocation = this
    }
});

$(document).on('click', '#submit-spawn', function(evt){
    evt.preventDefault(); //dont do default anchor stuff
    var location = $(this).data('location');
    var spawnType = $(this).data('type');
    console.log("Location: " + location + " \n SpawnType: " + spawnType + "\n New: " + new1);
    $(".container").addClass("hideContainer").fadeOut("9000");
    setTimeout(function(){
        $(".hideContainer").removeClass("hideContainer");
    }, 900);
    if (spawnType !== "appartment") {
        console.log(new1)
        $.post('https://zb-spawn/spawnplayer', JSON.stringify({
            spawnloc: location,
            typeLoc: spawnType,
			new: new1
        }));
    } else {
        $.post('https://zb-spawn/chooseAppa', JSON.stringify({
            appType: location,
			new: new1
        }));
    }
});

function setupLocations(locations, myHouses) {
    var parent = $('.spawn-locations')
    $(parent).html("");

    $(parent).append('<div class="loclabel" id="location" data-location="null" data-type="lab" data-label="Waar wil je beginnen?"><p><span id="null">Waar wil je beginnen?</span></p></div>')
    
    setTimeout(function(){
        $(parent).append('<div class="location" id="location" data-location="current" data-type="current" data-label="Laatste Locatie"><p><span id="current-location">Laatste Locatie</span></p></div>');
        
        $.each(locations, function(index, location){
            $(parent).append('<div class="location" id="location" data-location="'+location.location+'" data-type="normal" data-label="'+location.label+'"><p><span id="'+location.location+'">'+location.label+'</span></p></div>')
        });

        // if (myHouses != undefined) {
        //     $.each(myHouses, function(index, house){
        //         $(parent).append('<div class="location" id="location" data-location="'+house.house+'" data-type="house" data-label="'+house.label+'"><p><span id="'+house.house+'">'+house.label+'</span></p></div>')
        //     });
        // }

        $(parent).append('<div class="submit-spawn" id="submit-spawn"><p><span id="spawn-label"></span></p></div>');
        // $('.submit-spawn').hide();

        // Trigger de spawn
        // $("#current-location").trigger("click");
        // $("#submit-spawn").trigger("click");
        
        // $('.submit-spawn').hide();


        // $("#submit-spawn").delay(2000).trigger("click");
    }, 100)
}

function setupApps(apps) {
    var parent = $('.spawn-locations')
    $(parent).html("");

    $(parent).append('<div class="loclabel" id="location" data-location="null" data-type="lab" data-label="Kies een appartement."><p><span id="null">Kies een appartement</span></p></div>')

    $.each(apps, function(index, app){
        $(parent).append('<div class="location" id="location" data-location="'+app.name+'" data-type="appartment" data-label="'+app.label+'"><p><span id="'+app.name+'">'+app.label+'</span></p></div>')
    });

    $(parent).append('<div class="submit-spawn" id="submit-spawn"><p><span id="spawn-label"></span></p></div>');
    $('.submit-spawn').hide();
}

function kaasje() {
    $.post('https://zb-spawn/spawnplayer', JSON.stringify({
        spawnloc: "current",
        typeLoc: "current",
	    new: false
    }));
    $(".container").addClass("hideContainer").fadeOut("9000");
    setTimeout(function(){
        $(".hideContainer").removeClass("hideContainer");
    }, 900);

}