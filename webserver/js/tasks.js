document.querySelector(".popup-btn").addEventListener("click", () => {
  document.querySelector(".popup").remove();
});

window.onscroll = function() {stickyElements()};

var form = document.querySelector(".task-actions");
var sticky = form.offsetTop;

var menu = document.querySelector(".menu > ul");
var stickyM = menu.offsetTop;

function stickyElements() {
  if (window.pageYOffset+70 > sticky) {
    form.classList.add("sticky");
    let section = document.querySelector("section:nth-child(2)");
    section.style.paddingTop = "30px";
  } else {
    form.classList.remove("sticky");
    let section = document.querySelector("section:nth-child(2)");
    section.style.paddingTop = "";
  }

  if (window.pageYOffset+65 > stickyM) {
    menu.classList.add("sticky-menu");
  } else {
    menu.classList.remove("sticky-menu");
  }
}

