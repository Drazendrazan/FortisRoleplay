SetupTaxis = function(data) {
    $(".taxis-list").html("");

    if (data.length > 0) {
        $.each(data, function(i, taxi){
            var element = '<div class="taxi-list" id="taxiid-'+i+'"> <div class="taxi-list-firstletter">' + (taxi.name).charAt(0).toUpperCase() + '</div> <div class="taxi-list-fullname">' + taxi.name + '</div> <div class="taxi-list-call"><i class="fas fa-phone"></i></div> </div>'
            $(".taxis-list").append(element);
            $("#taxiid-"+i).data('TaxiData', taxi);
        });
    } else {
        var element = '<div class="taxi-list"><div class="no-taxis">Er zijn momenteel geen taxis beschikbaar.</div></div>'
        $(".taxis-list").append(element);
    }
}

$(document).on('click', '.taxi-list-call', function(e){
    e.preventDefault();

    var TaxiData = $(this).parent().data('TaxiData');
    
    var cData = {
        number: TaxiData.phone,
        name: TaxiData.name
    }

    $.post('http://fortis-phone/CallContact', JSON.stringify({
        ContactData: cData,
        Anonymous: QB.Phone.Data.AnonymousCall,
    }), function(status){
        if (cData.number !== QB.Phone.Data.PlayerData.charinfo.phone) {
            if (status.IsOnline) {
                if (status.CanCall) {
                    if (!status.InCall) {
                        if (QB.Phone.Data.AnonymousCall) {
                            QB.Phone.Notifications.Add("fas fa-phone", "Telefoon", "Je bent een anoniem gesprek gestart!");
                        }
                        $(".phone-call-outgoing").css({"display":"block"});
                        $(".phone-call-incoming").css({"display":"none"});
                        $(".phone-call-ongoing").css({"display":"none"});
                        $(".phone-call-outgoing-caller").html(cData.name);
                        QB.Phone.Functions.HeaderTextColor("white", 400);
                        QB.Phone.Animations.TopSlideUp('.phone-application-container', 400, -160);
                        setTimeout(function(){
                            $(".taxis-app").css({"display":"none"});
                            QB.Phone.Animations.TopSlideDown('.phone-application-container', 400, 0);
                            QB.Phone.Functions.ToggleApp("phone-call", "block");
                        }, 450);
    
                        CallData.name = cData.name;
                        CallData.number = cData.number;
                    
                        QB.Phone.Data.currentApplication = "phone-call";
                    } else {
                        QB.Phone.Notifications.Add("fas fa-phone", "Telefoon", "Je bent al in gesprek!");
                    }
                } else {
                    QB.Phone.Notifications.Add("fas fa-phone", "Telefoon", "Deze persoon is al in gesprek!");
                }
            } else {
                QB.Phone.Notifications.Add("fas fa-phone", "Telefoon", "Deze persoon is niet beschikbaar!");
            }
        } else {
            QB.Phone.Notifications.Add("fas fa-phone", "Telefoon", "Je kan jezelf niet bellen!");
        }
    });
});