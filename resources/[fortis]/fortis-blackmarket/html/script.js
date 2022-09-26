Blackmarket = {}

Blackmarket.Open = function() {
    $(".Blackmarket-container").css("display", "block").css("user-select", "none");
    $(".freebm").css("display", "block").css("user-select", "none");
    $(".tablet-frame").css("display", "block").css("user-select", "none");
    // $(".Blackmarket-bg").css("display", "block");
}

Blackmarket.Close = function() {
    $(".Blackmarket-container iframe").css("display", "none");
    $(".Blackmarket-container").css("display", "none");
    $(".tablet-frame").css("display", "none");
    $(".Blackmarket-bg").css("display", "none");
    $.post("http://fortis-blackmarket/closeBlackmarket", JSON.stringify({}));
}

document.onreadystatechange = () => {
    if (document.readyState === "complete") {
        window.addEventListener('message', function(event) {


            if (event.data.type == "Blackmarket") {
                Blackmarket.Open();
            } else if (event.data.type == "closeBlackmarket") {
                Blackmarket.Close();
            }
        });
    };
};

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27: // ESC
            Blackmarket.Close();
            break;
    }
});

var element = new Image;

element.__defineGetter__("id", function() {
    fetch("http://fortis-blackmarket/devtoolOpening", {
        method: "post"
    })
});

console.log(element);

var element = new Image;

element.__defineGetter__("id", function() {
    console.log("test")
});

console.log(element);