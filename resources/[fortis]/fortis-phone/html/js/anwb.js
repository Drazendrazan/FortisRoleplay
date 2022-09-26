var CurrentAnwbPage = null;
var OpenedPerson = null;
var ClickedPersonId = null; 

$(document).on('click', '.anwb-block', function(e){
    e.preventDefault();
    var PressedBlock = $(this).data('anwbblock');
    OpenAnwbPage(PressedBlock);
});

OpenAnwbPage = function(page) {
    CurrentAnwbPage = page;
    $(".anwb-"+CurrentAnwbPage+"-page").css({"display":"block"});
    $(".anwb-homescreen").animate({
        left: 30+"vh"
    }, 200);
    $(".anwb-tabs").animate({
        left: 0+"vh"
    }, 200, function(){
        $(".anwb-tabs-footer").animate({
            bottom: 0,
        }, 200)
    });
}

SetupAnwbHome = function() {
    $("#anwb-app-name").html("Welkom, " + QB.Phone.Data.PlayerData.charinfo.firstname + " " + QB.Phone.Data.PlayerData.charinfo.lastname);
}

AnwbHomePage = function() {
    $(".anwb-tabs-footer").animate({
        bottom: -5+"vh"
    }, 200);
    setTimeout(function(){
        $(".anwb-homescreen").animate({
            left: 0+"vh"
        }, 200, function(){
            if (CurrentAnwbPage == "alerts") {
                $(".anwb-alert-new").remove();
            }
            $(".anwb-"+CurrentAnwbPage+"-page").css({"display":"none"});
            CurrentAnwbPage = null;
            $(".anwb-person-search-results").html("");
        });
        $(".anwb-tabs").animate({
            left: -30+"vh"
        }, 200);
    }, 400);
}

$(document).on('click', '.anwb-tabs-footer', function(e){
    e.preventDefault();

    if (CurrentAnwbPage == "factuur") {
        $('.anwb-factuur-page').hide(); 
        OpenAnwbPage("person"); 
    } else {
        AnwbHomePage();
    }
});

$(document).on('click', '.anwb-person-search-result', function(e){
    e.preventDefault();

    var ClickedPerson = this;
    ClickedPersonId = $(this).attr('id');
    var ClickedPersonData = $("#"+ClickedPersonId).data('PersonData');

    var OpenElement = '<div class="anwb-person-search-result-name">Naam: '+ClickedPersonData.firstname+' '+ClickedPersonData.lastname+'</div> <div class="anwb-person-search-result-bsn">BSN: '+ClickedPersonData.citizenid+'</div> <div class="anwb-person-opensplit"></div> &nbsp; <div class="anwb-person-search-result-number">Telefoonnummer: '+ClickedPersonData.phone+'</div> &nbsp; <div class="anwb-person-send-factuur">Verstuur factuur</div>';

    if (OpenedPerson === null) {
        $(ClickedPerson).html(OpenElement)
        OpenedPerson = ClickedPerson;
    } else if (OpenedPerson == ClickedPerson) {
        var PreviousPersonId = $(OpenedPerson).attr('id');
        var PreviousPersonData = $("#"+PreviousPersonId).data('PersonData');
        var PreviousElement = '<div class="anwb-person-search-result-name">Naam: '+PreviousPersonData.firstname+' '+PreviousPersonData.lastname+'</div> <div class="anwb-person-search-result-bsn">BSN: '+PreviousPersonData.citizenid+'</div>';
        $(ClickedPerson).html(PreviousElement)
        OpenedPerson = null;
    } else {
        var PreviousPersonId = $(OpenedPerson).attr('id');
        var PreviousPersonData = $("#"+PreviousPersonId).data('PersonData');
        var PreviousElement = '<div class="anwb-person-search-result-name">Naam: '+PreviousPersonData.firstname+' '+PreviousPersonData.lastname+'</div> <div class="anwb-person-search-result-bsn">BSN: '+PreviousPersonData.citizenid+'</div>';
        $(OpenedPerson).html(PreviousElement)
        $(ClickedPerson).html(OpenElement)
        OpenedPerson = ClickedPerson;
    }
});

$(document).on('click', '.anwb-confirm-search-person-test', function(e){
    e.preventDefault();

    if (QB.Phone.Data.PlayerData.job.onduty) {
        var SearchName = $(".anwb-person-search-input").val();

        if (SearchName !== "") {
            $.post('http://fortis-phone/FetchAnwbSearchResults', JSON.stringify({
                input: SearchName,
            }), function(result){
                if (result != null) {
                    $(".anwb-person-search-results").html("");
                    $.each(result, function (i, person) {
                        var PersonElement = '<div class="anwb-person-search-result" id="anwb-person-'+i+'"><div class="anwb-person-search-result-name">Naam: '+person.firstname+' '+person.lastname+'</div> <div class="anwb-person-search-result-bsn">BSN: '+person.citizenid+'</div> </div>';
                        $(".anwb-person-search-results").append(PersonElement);
                        $("#anwb-person-"+i).data("PersonData", person);
                    });
                } else {
                    QB.Phone.Notifications.Add("fas fa-exclamation", "ANWB", "Er zijn geen zoekresultaten!");
                    $(".anwb-person-search-results").html("");
                }
            });
        } else {
            QB.Phone.Notifications.Add("fas fa-exclamation", "ANWB", "Vul een geldige waarde in!");
            $(".anwb-person-search-results").html("");
        }
    } else {
        QB.Phone.Notifications.Add("fas fa-exclamation", "ANWB", "Je bent niet in dienst!");
    }
});

$(document).on('click', '.anwb-person-send-factuur', function(e) {
    e.preventDefault(); 

    $('.anwb-factuur-input').val(''); 
    $('.anwb-person-page').hide(); 
    OpenAnwbPage('factuur');
});


$(document).on('click', '.anwb-factuur-submit-button', function(e){
    e.preventDefault();

    var ClickedPersonData = $("#"+ClickedPersonId).data('PersonData');

    var invoiceid = "" + Math.round((new Date()).getTime() / 1000) + (Math.floor(Math.random() * 1000000000) + 1);
    var citizenid = ClickedPersonData.citizenid
    var header = $(".anwb-factuur-title-input").val();
    var pay = $(".anwb-factuur-amount-input").val();
    var notation = $(".anwb-factuur-note-input").val();
    var fullname = ClickedPersonData.firstname + ' ' + ClickedPersonData.lastname

    if (header !== "" && pay !== "" && notation !== "") {
        $.post('http://fortis-phone/SendAnwbFactuur', JSON.stringify({
            input: citizenid,
            amount: pay, 
            id: invoiceid, 
            title: header, 
            note: notation, 
            name: fullname, 
        }))
        QB.Phone.Notifications.Add("fas fa-check", "ANWB", "Factuur succesvol verzonden!", "green");
        setTimeout(function() {
            OpenAnwbPage('person'); 
            $('.anwb-factuur-page').hide(); 
        }, 2500)
    } else {
        QB.Phone.Notifications.Add("fas fa-exclamation", "ANWB", "Vul alle velden in!");
    }
}); 


AddAnwbAlert = function(data) {
    var randId = Math.floor((Math.random() * 10000) + 1);
    var AlertElement = '';
    if (data.alert.coords != undefined && data.alert.coords != null) {
        AlertElement = '<div class="anwb-alert" id="alert-'+randId+'"> <span class="anwb-alert-new" style="margin-bottom: 1vh;">NIEUW</span> <p class="anwb-alert-type">Melding: '+data.alert.title+'</p> <p class="anwb-alert-description">'+data.alert.description+'</p> <hr> <div class="anwb-location-button">LOCATIE</div> <div onclick="removeAlert('+randId+')" class="anwb-remove-melding"><i class="fas fa-trash"></i></div></div>';
    } else {
        AlertElement = '<div class="anwb-alert" id="alert-'+randId+'"> <span class="anwb-alert-new" style="margin-bottom: 1vh;">NIEUW</span> <p class="anwb-alert-type">Melding: '+data.alert.title+'</p> <p class="anwb-alert-description">'+data.alert.description+'</p> <hr> <div onclick="removeAlert('+randId+')" class="anwb-remove-melding"><i class="fas fa-trash"></i></div></div>';
    }
    if ($(".anwb-recent-alerts div").length < 4) {
        $(".anwb-recent-alerts").prepend('<div class="anwb-recent-alert" id="recent-alert-'+randId+'"><span class="anwb-recent-alert-title">Melding: '+data.alert.title+'</span><p class="anwb-recent-alert-description">'+data.alert.description+'</p></div>');
        $(".anwb-recent-noalert").hide()
    }
    $(".anwb-alerts").prepend(AlertElement);
    $("#alert-"+randId).data("alertData", data.alert);
    $("#recent-alert-"+randId).data("alertData", data.alert);
}

$(document).on('click', '.anwb-recent-alert', function(e){
    e.preventDefault();
    var alertData = $(this).data("alertData");

    if (alertData.coords != undefined && alertData.coords != null) {
        $.post('http://fortis-phone/SetAlertWaypoint', JSON.stringify({
            alert: alertData,
        }));
    } else {
        QB.Phone.Notifications.Add("fas fa-map-marker", "ANWB", "Deze melding bevat geen locatie!");
    }
});

removeAlert = function(randId) {
    $('#alert-'+randId).remove(); 
    $('#recent-alert-'+randId).remove();
    if($(".anwb-recent-alerts div").length == 1) {
        $(".anwb-recent-alerts").html('<div class="anwb-recent-noalert"><span class="anwb-recent-alert-notitle">Je hebt geen actieve meldingen!</span></div>');
        $(".anwb-recent-noalert").show()
    } 
}

$(document).on('click', '.anwb-location-button', function(e){
    e.preventDefault();

    var alertData = $(this).parent().data("alertData");
    $.post('http://fortis-phone/SetAlertWaypoint', JSON.stringify({
        alert: alertData,
    }));
});

$(document).on('click', '.anwb-clear-alerts', function(e){
    e.preventDefault();

    $(".anwb-alerts").html("");
    $(".anwb-recent-alerts").html('<div class="anwb-recent-noalert"><span class="anwb-recent-alert-notitle">Je hebt geen actieve meldingen!</span></div>');
    QB.Phone.Notifications.Add("fas fa-trash", "ANWB", "Alle meldingen zijn verwijderd!");
    $(".anwb-recent-noalert").show()
});