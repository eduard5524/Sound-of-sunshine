if (document.querySelector(".popup-btn") != null) {
  document.querySelector(".popup-btn").addEventListener("click", () => {
    document.querySelector(".popup").remove();
  });
}

window.onscroll = function() {stickyMenu()};

var menu = document.querySelector(".menu > ul");
var stickyM = menu.offsetTop;

function stickyMenu() {
  if (window.pageYOffset+65 > stickyM) {
    menu.classList.add("sticky-menu");
  } else {
    menu.classList.remove("sticky-menu");
  }
}
