import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["card", "name", "value", "output"];
  connect() {}
  search() {
    if (this.hasCardTarget) {
      this.filter(this.nameTargets, this.valueTarget.value);
    }
  }
  filter(elements, value) {
    elements.map((element) => {
      if (element.innerText.includes(value)) {
        document.getElementById(element.innerText).classList.remove("hidden");
      } else {
        document.getElementById(element.innerText).classList.add("hidden");
      }
    });
  }
}

