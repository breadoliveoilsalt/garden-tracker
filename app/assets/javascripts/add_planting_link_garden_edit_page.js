// jQuery iife.  For formatting and reasoning, see here:
// http://gregfranko.com/blog/jquery-best-practices/

(function(setupForNewPlanting){

    setupForNewPlanting(window.jQuery, window, document)

  }
    // Starting with this first parenthesis below: this basically (1) calls the anonymous
    // function AND (2) passes in all of the stuff below as the anonymous
    // function's argument, the original "setupForNewPlanting"

    (function($, window, document) {

      // Start of heart of code.
      // On document ready:
    $(function () {
      attachAddPlantingLinkListener()
    })

    function attachAddPlantingLinkListener() {
      $("#add-planting-link").on("click", displayNewPlantingForm)
    }

    function displayNewPlantingForm(event) {
      event.preventDefault()

      const userId = event.target.dataset.userId
      const gardenId = event.target.dataset.gardenId
      const urlRequest = `/users/${userId}/gardens/${gardenId}/plantings/new`

      $.ajax({
        url: urlRequest,
        method: `GET`
      })
      .then(function(response) {
        const newPlantingForm = $(response).filter("#new-planting-form")[0].outerHTML
        $("#new-planting-form-container")[0].innerHTML = newPlantingForm
          // Remove link to add new garden
        $("#add-planting-link-container")[0].innerHTML = ""
        $([document.documentElement, document.body]).animate({
           scrollTop: $("#new-planting-form-container").offset().top
       }, 1000);
      })
    } // End of heart of code.
  }
))
