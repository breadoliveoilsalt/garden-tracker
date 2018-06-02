
  // Note that the following would not work in this file
  // for some reason.  See also notes in gardens.js:
    // $(document).on('turbolinks:load', function() {
    // $(document).ready(function () {
    // $(document).on('page:load', function() {

$(window).load(function() {
  attachSpeciesShowListeners()
  attachSpeciesNewFormListener()
})

function attachSpeciesShowListeners() {
  $(".species_show_link").on("click", function(e) {

      e.preventDefault()

      let userId = $(this).data().userId
      let speciesId = $(this).data().speciesId
      let displayBox = $("#species_display_id_" + speciesId)

        // To prevent duplication of data insert in event user clicks on link twice.
        // displayBox.empty() works but looks awkward when the request is made

      if (displayBox.text() === "") {
        $.ajax({
          url: `/users/${userId}/species/${speciesId}.json`,
          method: "GET"
        }).done(function(data){
          let speciesObject = new Species(data["id"], data["name"], data["product"], data["sunlight"], data["gardens"], data["user"])
          displayBox.append(speciesObject.renderShow())
        }).fail(function() {
          displayBox.append("Sorry, there was an error.")
        })
      }
   }) // end of .on("click")
}

class Species {
  constructor(id, name, product, sunlight, gardens, user) {
    this.id = id
    this.name = name
    this.product = product
    this.sunlight = sunlight
    this.gardens = gardens
    this.user = user
  }

  renderShow() {
    let gardens = $(this.gardens)
    return `
      Product: ${this.product} <br>
      Sunlight: ${this.sunlight} <br>
      Your Gardens Where This Appears: <br> ${this.renderGardens(gardens)}
      `
  }

  renderGardens(gardens) {
      // Note that gardens here is jQuery object
    let text = ""

    gardens.each(function(index, garden) {
      text += `<a class="indented" href="/users/${garden['userId']}/gardens/${garden['id']}"> ${garden['name']} </a> <br>`
    })

    return text
  }

  renderAbbreviatedShow() {
    return `<li> ${this.name} --

          <a class="species_show_link" data-species-id="${this.id}" data-user-id="${this.user.id}" href="#">Show Info</a> --

          <a href="/users/${this.user.id}/species/${this.id}">Edit/Destroy Page</a>

          <div id="species_display_id_${this.id}"></div>
        </li>`

  }
}

///// CODE RELATED TO SPECIES NEW FORM /////

function attachSpeciesNewFormListener() {
  $("#species_new_form_link").on("click", function(e) {
    e.preventDefault()

    let userId = $(this).data().userId

    $.ajax({
      url: `/users/${userId}/species/new`,
      method: "GET"
    })

    .then( function (data) {
      let baseHTML = $(data).filter("form#new_species")
      let formHTML = '<div id="species_form_container">' + baseHTML[0].outerHTML + '</div>'
      return formHTML
    })

    .then(function(formHTML) {
      let speciesHeader = $("#species_header")[0]
      $(formHTML).insertAfter($(speciesHeader))
    })

    .then(function () {
      attachSpeciesSubmitListener()
    })

  })
}

function attachSpeciesSubmitListener() {
  $("form#new_species").submit(function(e) {
    e.preventDefault()

    let formValues = $(this).serialize()

    $.ajax( {
        url: $(this)[0].action,
        method: $(this)[0].method.toUpperCase(),
        data: formValues
      })

      // Note: in the SpeciesController under #create, if the object fails to save
      // to the database, the errors are returned as well as a status code in the 400s.
      // It is that "failure" status code that makes the ajax promise here skip over
      // all the .then(s) and go straight to .failure().

    .then(function(data) {
      let speciesObject = new Species(data["id"], data["name"], data["product"], data["sunlight"], data["gardens"], data["user"])

      $("#species_list").append(speciesObject.renderAbbreviatedShow())
    })

    .then(function() {
        // Remove the form submitted
      $("#species_form_container").remove()
        // Remove all prior event handlers to show info for the species,
        // otherwise there is a doubling bug where the show species link will
        // show the species info twice.
      $(".species_show_link").off()
    })
    .then(function() {
      // Then reattach all listeners to the species show links, including the
      // newly created link.

      // Note: in future revisions you can probably rely on event delegation
      // aka bubbling.  See: https://learn.jquery.com/events/event-delegation/
      attachSpeciesShowListeners()

      // This hits if the ajax request doesn't work or if a 400 code is returned:
      // an alert pop up letting the user know what errors have occurred.
    }).fail(function(data) {
      let errorCollection = data.responseJSON.errors
      let message = ""
      $(errorCollection).each(function(i, el) {
        message += el + ". "
      })
      alert("Sorry, the following errors occurred: " + message)

    })
  }) // end of submit call
} // end of function
