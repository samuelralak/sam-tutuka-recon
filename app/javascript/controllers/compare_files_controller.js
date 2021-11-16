import { Controller } from "@hotwired/stimulus"
import Rails from "@rails/ujs";

const compareBtn = {
  disabledClass: ["opacity-30", "cursor-not-allowed"],
  text: "Compare files",
  inProgressText: "Please wait..."
}

// Connects to data-controller="compare-files"
export default class extends Controller {
  connect() {
    $(document).on('compare_files_controller.state', function(event, callback) {
      callback(this)
    }.bind(this))

    this.disableCompareBtn()
  }

  static targets = ["keyOneInput", "keyTwoInput", "compareFilesForm", "compareBtn"];
  static values = { keyOne: String, keyTwo: String }

  onSuccess(event) {
    const [_data, _status, xhr] = event.detail;
    const parentElement = this.element.parentElement;

    this.deleteNextSibling(parentElement.nextElementSibling);
    parentElement.insertAdjacentHTML("afterend", xhr.response);
  }

  enableCompareBtn() {
    if (this.keyOneValue.length > 0 && this.keyTwoValue.length > 0) {
      this.compareBtnTarget.disabled = false;
      this.compareBtnTarget.classList.remove(...compareBtn.disabledClass);
    }
  }

  disableCompareBtn() {
    this.compareBtnTarget.disabled = true;
    this.compareBtnTarget.classList.add(...compareBtn.disabledClass);
  }

  compare() {
    this.keyOneInputTarget.value = this.keyOneValue;
    this.keyTwoInputTarget.value = this.keyTwoValue;
    Rails.fire(this.compareFilesFormTarget, 'submit');
  }

  onFormSend(event) {
    this.disableCompareBtn()
    this.compareBtnTarget.textContent = compareBtn.inProgressText;
  }

  onFormCompleted(event) {
    this.enableCompareBtn()
    this.compareBtnTarget.textContent = compareBtn.text;
  }

  deleteNextSibling(element) {
    if (!element) {
      return
    }

    const next = element.nextElementSibling;
    element.remove();
    this.deleteNextSibling(next);
  }
}
