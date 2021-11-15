import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="reports"
export default class extends Controller {
  connect() {
    $(document).on('reports_controller.state', function(event, callback) {
      callback(this)
    }.bind(this))
  }

  static targets = ["keyOneInput", "keyTwoInput", "unmatchedReportForm"];
  static values = { keyOne: String, keyTwo: String }

  onSuccess(event) {
    console.log("Report fetch success...")
  }

  prepareReport() {
    $(document).trigger("comparison_results_controller.state", function (controller) {
      console.log(controller.ca)
    })
  }
}
