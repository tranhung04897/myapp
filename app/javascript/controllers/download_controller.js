import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
  }
  change_issue_range(event) {
    if (event.target.value.length > 0) {
      $('#year_issue_date').prop('disabled', true);
      $('#month_issue_date').prop('disabled', true);
    } else {
      $('#year_issue_date').prop('disabled', false);
      $('#month_issue_date').prop('disabled', false);
    }
  }
  change_flt_range(event) {
    if (event.target.value.length > 0) {
      $('#year_flt_date').prop('disabled', true);
      $('#month_flt_date').prop('disabled', true);
    } else {
      $('#year_flt_date').prop('disabled', false);
      $('#month_flt_date').prop('disabled', false);
    }
  }
  change_issue_year(event) {
    if (event.target.value.length > 0) {
      $('#issue_date_range').prop('disabled', true);
    } else {
      if ($("#month_issue_date").val().length == 0){
        $('#issue_date_range').prop('disabled', false);
      }
    }
  }
  change_issue_month(event) {
    if (event.target.value.length > 0) {
      $('#issue_date_range').prop('disabled', true);
    } else {
      if ($("#year_issue_date").val().length == 0){
        $('#issue_date_range').prop('disabled', false);
      }
    }
  }

  change_flt_year(event) {
    if (event.target.value.length > 0) {
      $('#flt_date_range').prop('disabled', true);
    } else {
      if ($("#month_flt_date").val().length == 0){
        $('#flt_date_range').prop('disabled', false);
      }
    }
  }
  change_flt_month(event) {
    if (event.target.value.length > 0) {
      $('#flt_date_range').prop('disabled', true);
    } else {
      if ($("#year_flt_date").val().length == 0){
        $('#flt_date_range').prop('disabled', false);
      }
    }
  }
}
