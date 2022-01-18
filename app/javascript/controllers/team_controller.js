import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["card", "name", "value", "output"];
  connect() {}
  search() {
    if (this.hasCardTarget) {
      this.filter(this.cardTargets, this.valueTarget.value);
    }
  }
  filter(elements, value) {
    elements.map((element) => {
      if (element.innerText.includes(value)) {
        element.classList.remove("hidden");
      } else {
        element.classList.add("hidden");
      }
    });
  }
}
