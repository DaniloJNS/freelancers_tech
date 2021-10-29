import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["text"];
  connect() {
    console.log("Hello World", this.element);
  }
  greet() {
    const element = this.textTarget;
    this.element.classList.add("bg-blue-500");
    this.element.lastElementChild.textContent = element.value;
  }
}
