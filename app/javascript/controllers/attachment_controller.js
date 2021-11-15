import { Controller } from "@hotwired/stimulus"
import Rails from "@rails/ujs";

// Connects to data-controller="compare-files"
export default class extends Controller {
  static targets = ["attachmentInput", "fileNameInput", "attachmentForm"];
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

  // Form submit events

  onFormSend() {
    console.log("Form is sending...")
  }

  onSuccess(event) {
    const [data, status, xhr] = event.detail;
    const formId = this.attachmentFormTarget.id;

    $(document).trigger("compare_files_controller.state", function (compareFilesController) {
      if (formId === "file1") {
        compareFilesController.keyOneValue = data;
      }

      if (formId === "file2") {
        compareFilesController.keyTwoValue = data;
      }
    })
  }

  onError() {
    console.log("Form is error...")
  }

  onFormCompleted(event) {
    const [data, status, xhr] = event.detail
    console.log({xhr})
  }
}
