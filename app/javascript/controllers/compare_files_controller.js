import { Controller } from "@hotwired/stimulus"
import Rails from "@rails/ujs";

// Connects to data-controller="compare-files"
export default class extends Controller {
  connect() {
    $(document).on('compare_files_controller.state', function(event, callback) {
      callback(this)
    }.bind(this))
  }

  static targets = ["keyOneInput", "keyTwoInput", "compareFilesForm"];
  static values = { keyOne: String, keyTwo: String }

  onSuccess(event) {
    const [_data, _status, xhr] = event.detail;
    this.element.parentElement.insertAdjacentHTML("afterend", xhr.response);
  }

  compare() {
    this.keyOneInputTarget.value = this.keyOneValue;
    this.keyTwoInputTarget.value = this.keyTwoValue;
    Rails.fire(this.compareFilesFormTarget, 'submit');
  }
}
