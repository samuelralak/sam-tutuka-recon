import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="reports"
export default class extends Controller {
  connect() {
    $(document).on('reports_controller.state', function(event, callback) {
      callback(this)
    }.bind(this))
  }

  static targets = ["showMatchesLink"]

  hideModal() {
    this.element.classList.add("hidden")
  }

  showPossibleMatches(event) {
    const [xhr, _status] = event.detail;

    if (xhr.status === 200) {
      const targetElement = event.target.parentElement.parentElement;
      targetElement.insertAdjacentHTML("afterend", xhr.response);
    }
  }
}
