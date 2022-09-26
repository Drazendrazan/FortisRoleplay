
$(document).ready(function(){
 window.addEventListener( 'message', function( event ) {
        var item = event.data;
        if ( item.showPlayerMenu == true ) {
            $('body').css('background-color','transparent');

            $('#divp').fadeIn("fast");
        } else if ( item.showPlayerMenu == false ) { // Hide the menu

            $('#divp').fadeOut("fast");
            $('body').css('background-color','transparent important!');
            $("body").css("background-image","none");
            setTimeout(function() {
                document.location.reload(true);
            }, 500);
        }
 } );
        
	
        $(document).keyup(function(e) {
            if ( e.keyCode == 27 ) { 
                $('#divp').fadeOut("fast");
                $.post('http://lotto/closeButton', JSON.stringify({}));
           }
        });

    });
