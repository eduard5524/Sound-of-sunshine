const dropdowns = document.querySelectorAll(".dropdown");

for (const dropdown of dropdowns) {
  dropdown.addEventListener("mouseenter", function(event) {
    dropdown.classList.add("open");
  });

  dropdown.addEventListener("mouseleave", function(event) {
    dropdown.classList.remove("open");
  });

  dropdown.querySelector('.dropdown-items').addEventListener('click', function(event) {
    let dropdownText = dropdown.querySelector(".dropdown-button");
    let item = dropdown.querySelector(".dropdown-items").getElementsByTagName("div")[0];

    if (item.innerHTML == "Accept" || item.innerHTML == "Drop") {
      if (item.innerHTML == "Accept") {
        item.parentNode.parentNode.parentNode.parentNode.querySelector("input[name='policy']").value = "ACCEPT";
      } else {
        item.parentNode.parentNode.parentNode.parentNode.querySelector("input[name='policy']").value = "DROP";
      }
    } else if (item.innerHTML == "Insert" || item.innerHTML == "Append") {
      if (item.innerHTML == "Insert") {
        item.parentNode.parentNode.parentNode.querySelector("input[name='method']").value = "I";
      } else {
        item.parentNode.parentNode.parentNode.querySelector("input[name='method']").value = "A";
      }
    } else if (item.innerHTML == "Interrupt") {
        let div = document.createElement("div");
        div.classList.add("form-label");
        div.innerHTML = 'Seconds: <input name="seconds" type="numeric" dir="rtl" required>';

        document.querySelector(".task-inputs").appendChild(div);
    } else {
        document.querySelector(".task-inputs").lastChild.remove();
      }

    var aux = dropdownText.innerHTML;
    dropdownText.innerHTML = item.innerHTML;
    item.innerHTML = aux;

    dropdown.classList.remove("open");
  });
}

