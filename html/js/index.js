var elementTime = document.getElementById("time");
var elementScore = document.getElementById("score");

$(function() {
  window.addEventListener('message', function(event) {
    if (event.data.HUD == "Green"){
      elementTime.innerHTML = event.data.Time;
      elementScore.innerHTML = event.data.Score;
      $('#body').css('display', 'block')
      $('#imgGreen').css('display', 'block')
    }else if (event.data.HUD == "Red"){
      elementTime.innerHTML = event.data.Time;
      elementScore.innerHTML = event.data.Score;
      $('#body').css('display', 'block')
      $('#imgRed').css('display', 'block')
    }else if (event.data.HUD == false){
      $('#body').css('display', 'none')
      $('#imgGreen').css('display', 'none')
      $('#imgRed').css('display', 'none')
    }
  });
});