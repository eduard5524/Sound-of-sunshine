let time = document.querySelector(".time-on").innerHTML.split(" ");
let days = time[0].replace("D", "");
let hours = time[1].replace("h", "");
let minutes = time[2].replace("m", "");
let seconds = time[3].replace("s", "");

days + 0;
hours + 0;
minutes + 0;
seconds + 0;

function clock() {
  setTimeout(() => {
    seconds++;
    if (seconds == 60) {
      minutes++;
      seconds = "0";
    }

    if (minutes == 60) {
      hours++;
      minutes = "0";
    }

    if (hours == 24) {
      days++;
      hours = "0";
    }

    updateTime();
    clock();
  }, 1000);
}

function updateTime() {
  hours = "" + hours;
  minutes = "" + minutes;
  seconds = "" + seconds;
  
  hours = hours.length < 2 ? "0" + hours : hours;
  minutes = minutes.length < 2 ? "0" + minutes : minutes;
  seconds = seconds.length < 2 ? "0" + seconds : seconds;

  let newTime = days + "D " + hours + "h " + minutes + "m " + seconds + "s";
  document.querySelector(".time-on").innerHTML = newTime;
}

clock();

