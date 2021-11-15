import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="comparison-results"
export default class extends Controller {
  connect() {
    $(document).on('comparison_results_controller.state', function(event, callback) {
      callback(this)
    }.bind(this))
  }

  static targets = ["results"];
  static values = { cacheKeys: Array }

  showUnmatched() {
    $(document).trigger("reports_controller.state", function (controller) {
      controller.element.style.display = "block"
    })
  }
}
