import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["refused", "form", "info", "error"];
  connect() {
    this.element.classList.remove("hidden");
    if (this.hasErrorTarget) {
      this.refused();
    }
  }
  replace(event) {
    event.preventDefault();
    event.stopPropation();

    const [, , xhrHTTP] = event.detail;
    this.element.remove();
    if (event.target.classList.contains("js-action")) {
      this.element.remove();
      this.formTarget.innerHTML = xhrHTTP.responseText;
    }
  }
  close() {
    setTimeout(() => {
      this.element.remove();
    }, 100);
  }
  refused() {
    this.refusedTarget.classList.add("hidden");
    this.infoTarget.classList.add("hidden");
    this.formTarget.classList.remove("hidden");
  }
  cancel() {
    this.formTarget.classList.add("hidden");
    this.refusedTarget.classList.remove("hidden");
    this.infoTarget.classList.remove("hidden");
  }
}
