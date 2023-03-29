// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

$(document).on('turbo:load', () => {
})
$(document).on('change', '.input-checkbox input[type="checkbox"]', function() {
  let $tableSelect = $(this).closest('.js-table-checkbox-delete');
  let $selectall = $tableSelect.find('.input-checkbox input[name="btSelectAll"]');
  let itemCheckbox = $tableSelect.find('tbody .input-checkbox input[type="checkbox"]').length;
  let itemCheckboxChecked = $tableSelect.find('tbody .input-checkbox input[type="checkbox"]:checked').length;

  if ($selectall.is(':checked') == true) {
    $tableSelect.find('.btn-del-min-v1').attr('disabled', false);
  } else {
    $tableSelect.find('.btn-del-min-v1').attr('disabled', true);
  }

  if ($(this).attr('name') == 'btSelectAll') {
    $tableSelect.find('.input-checkbox input[type="checkbox"]').prop('checked', this.checked);
  } else {
    if (itemCheckbox == itemCheckboxChecked) {
      $selectall.prop("checked", true);
    } else {
      $selectall.prop("checked", false);
    }

    if (itemCheckboxChecked >=1 ) {
      $tableSelect.find('.btn-del-min-v1').attr('disabled', false);
    } else {
      $tableSelect.find('.btn-del-min-v1').attr('disabled', true);
    }
  }
});
(function($) {
  "use strict"; // Start of use strict

  // Toggle the side navigation
  $("#sidebarToggle, #sidebarToggleTop").on('click', function(e) {
    $("body").toggleClass("sidebar-toggled");
    $(".sidebar").toggleClass("toggled");
    if ($(".sidebar").hasClass("toggled")) {
      $('.sidebar .collapse').collapse('hide');
    };
  });

  // Close any open menu accordions when window is resized below 768px
  $(window).resize(function() {
    if ($(window).width() < 768) {
      $('.sidebar .collapse').collapse('hide');
    };

    // Toggle the side navigation when window is resized below 480px
    if ($(window).width() < 480 && !$(".sidebar").hasClass("toggled")) {
      $("body").addClass("sidebar-toggled");
      $(".sidebar").addClass("toggled");
      $('.sidebar .collapse').collapse('hide');
    };
  });

  // Prevent the content wrapper from scrolling when the fixed side navigation hovered over
  $('body.fixed-nav .sidebar').on('mousewheel DOMMouseScroll wheel', function(e) {
    if ($(window).width() > 768) {
      var e0 = e.originalEvent,
        delta = e0.wheelDelta || -e0.detail;
      this.scrollTop += (delta < 0 ? 1 : -1) * 30;
      e.preventDefault();
    }
  });

  // Scroll to top button appear
  $(document).on('scroll', function() {
    var scrollDistance = $(this).scrollTop();
    if (scrollDistance > 100) {
      $('.scroll-to-top').fadeIn();
    } else {
      $('.scroll-to-top').fadeOut();
    }
  });

  // Smooth scrolling using jQuery easing
  $(document).on('click', 'a.scroll-to-top', function(e) {
    var $anchor = $(this);
    $('html, body').stop().animate({
      scrollTop: ($($anchor.attr('href')).offset().top)
    }, 1000, 'easeInOutExpo');
    e.preventDefault();
  });

})(jQuery); // End of use strict
