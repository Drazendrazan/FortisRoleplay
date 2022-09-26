SetupMakelaar = function(data) {
    $(".makelaars-list").html(""); 
    if (data.length > 0) {
        $.each(data, function(i, lawyer){
            var element = '<div class="makelaar-list" id="lawyerid-'+i+'"> <div class="makelaar-list-firstletter">' + (lawyer.name).charAt(0).toUpperCase() + '</div> <div class="makelaar-list-fullname">' + lawyer.name + '</div> <div class="makelaar-list-call"><i class="fas fa-phone"></i></div> </div>'
            $(".makelaars-list").append(element);
            $("#lawyerid-"+i).data('LawyerData', lawyer);
        });
    } else {
        var element = '<div class="makelaar-list"><div class="no-makelaars">Er zijn momenteel geen makelaars beschikbaar.</div></div>'
        $(".makelaars-list").append(element);
    }
}

$(document).on('click', '.makelaar-list-call', function(e){
    e.preventDefault();

    var LawyerData = $(this).parent().data('LawyerData');
    
    var cData = {
        number: LawyerData.phone,
        name: LawyerData.name
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
                            $(".lawyers-app").css({"display":"none"});
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