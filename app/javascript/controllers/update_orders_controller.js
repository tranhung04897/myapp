import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="update-orders"
export default class extends Controller {
  connect() {
    // console.log('aa');
  }
  change(event) {
    event.preventDefault();
    event.target.form.requestSubmit();
   // var formId = event.target.getAttribute("data-id");
   // $(`#myForm_${formId}`).requestSubmit();
  }
}
