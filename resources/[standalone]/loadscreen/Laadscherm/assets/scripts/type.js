var Text = function (el, toRotate, period) {
  this.toRotate = toRotate;
  this.el = el;
  this.loopNum = 0;
  this.period = parseInt(period, 10) || 2000;
  this.txt = '';
  this.tick();
  this.isDeleting = false;
};

Text.prototype.tick = function () {
  var i = this.loopNum % this.toRotate.length;
  var fullTxt = this.toRotate[i];

  if (this.isDeleting) {
    this.txt = fullTxt.substring(0, this.txt.length - 1);
  } else {
    this.txt = fullTxt.substring(0, this.txt.length + 1);
  }

  this.el.innerHTML = '<span class="wrap">' + this.txt + '</span>';

  var that = this;
  var delta = 200 - Math.random() * 100;

  if (this.isDeleting) {
    delta /= 2;
  }

  if (!this.isDeleting && this.txt === fullTxt) {
    delta = this.period;
    this.isDeleting = true;
  } else if (this.isDeleting && this.txt === '') {
    this.isDeleting = false;
    this.loopNum++;
    delta = 500;
  }

  setTimeout(function () {
    that.tick();
  }, delta);
};

window.onload = function () {
  var elements = document.getElementsByClassName('typewrite');
  for (var i = 0; i < elements.length; i++) {
    var toRotate = elements[i].getAttribute('data-woorden');
    var period = elements[i].getAttribute('data-period');
    if (toRotate) {
      new Text(elements[i], JSON.parse(toRotate), period);
    }
  }
};

const cursor = document.querySelector(".cursor");
var timeout;

//follow cursor on mousemove
document.addEventListener("mousemove", (e) => {
  let x = e.pageX;
  let y = e.pageY;

  cursor.style.top = y + "px";
  cursor.style.left = x + "px";
  cursor.style.display = "block";
});

//cursor effects when mouseout
document.addEventListener("mouseout", () => {
  cursor.style.display = "none";
});

window.addEventListener("message", function(event) {
  if (event.data.type == "sluit") {
    ladenKlaar();
  }
});

function ladenKlaar() {
  $("#laadschermLogo").fadeOut();
  $("#laadschermText").fadeOut();
  $(".laadbalk").fadeOut();
  $("#muziek-uitleg-txt").fadeOut();
  $("html").css("margin-top", "-5000px");
}

var character = document.getElementById("character");
var block = document.getElementById("block");
var counter = 0;

function openGame() {
  counter = 0;
  $("#game").fadeIn();
  document.getElementById('block').style.display = "block";
  // document.getElementById('game').style.display = "block";
  // document.getElementById('laadbalk').style.display = "none";
}

function jump() {
  if(character.classList == "animate"){return}
    character.classList.add("animate");
    setTimeout(function(){
    character.classList.remove("animate");
  },400);
}

var checkDead = setInterval(function() {
  let characterTop = parseInt(window.getComputedStyle(character).getPropertyValue("top"));
  let blockLeft = parseInt(window.getComputedStyle(block).getPropertyValue("left"));
  if (blockLeft < 20 && blockLeft >- 20 && characterTop > 130){
      document.getElementById('block').style.display = "none";
      $("#game").fadeOut();
      counter = 0;
  } else {
      counter = counter + 1;
      document.getElementById("scoreSpan").innerHTML = Math.floor(counter/100);
  }
}, 12);
