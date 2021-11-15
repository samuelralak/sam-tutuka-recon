import { Controller } from "@hotwired/stimulus"
import Rails from "@rails/ujs";

const browseBtn = {
  disabledClass: ["opacity-30", "cursor-not-allowed"],
  text: "Browse",
  inProgressText: "Processing..."
}

// Connects to data-controller="compare-files"
export default class extends Controller {
  static targets = ["attachmentInput", "fileNameInput", "attachmentForm", "browseBtn"];
  static values = { keyOne: String, keyTwo: String }

  browse() {
    // Trigger click event on file input
    this.attachmentInputTarget.click();
  }

  onFileChange() {
    // Display selected file
    const {name: fileName} = this.attachmentInputTarget.files.item(0);
    this.fileNameInputTarget.value = fileName;

    // Submit form with CSV file
    Rails.fire(this.attachmentFormTarget, 'submit');
  }

  enableBrowseBtn() {
    this.browseBtnTarget.disabled = false;
    this.browseBtnTarget.classList.remove(...browseBtn.disabledClass);
  }

  disableBrowseBtn() {
    this.browseBtnTarget.disabled = true;
    this.browseBtnTarget.classList.add(...browseBtn.disabledClass);
  }

  // Form submit events

  onFormSend() {
    this.disableBrowseBtn()
    this.browseBtnTarget.textContent = browseBtn.inProgressText;
  }

  onSuccess(event) {
    const [data, status, xhr] = event.detail;
    const formId = this.attachmentFormTarget.id;

    $(document).trigger("compare_files_controller.state", function (controller) {
      switch (formId) {
        case "file1":
          controller.keyOneValue = data;
          break;
        case "file2":
          controller.keyTwoValue = data;
          break;
      }

      controller.enableCompareBtn();
    })
  }

  onError(event) {
    const [data, status, xhr] = event.detail;
    $(document).trigger("errors_controller.state", function (controller) {
      controller.showErrors(data.errors);
      controller.element.style.display = "block";
    })
  }

  onFormCompleted(event) {
    this.enableBrowseBtn();
    this.browseBtnTarget.textContent = browseBtn.text;
  }
}
