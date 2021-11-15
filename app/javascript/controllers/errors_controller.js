import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="errors"
export default class extends Controller {
  connect() {
    $(document).on('errors_controller.state', function(event, callback) {
      callback(this)
    }.bind(this))
  }

  static targets = ["errorsList"];

  showErrors(errors) {
    for (const key in errors) {
      const errElement = document.createElement("li")
      errElement.innerText = `${key} ${errors[key].join(", ")}`;
      this.errorsListTarget.append(errElement);
    }
  }
}
