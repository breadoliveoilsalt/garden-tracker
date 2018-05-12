let user_id

$(function () {
  attachSpeciesShowListeners()
  attachSpeciesNewFormListener()
})


function attachSpeciesShowListeners() {
  $(".species_show_link").on("click", function(e) {

      e.preventDefault()

      user_id = $(this).data().userId
      let species_id = $(this).data().speciesId
      let displayBox = $("#species_display_id_" + species_id)


        // To prevent duplication of data insert in event user clicks on link twice.
        // displayBox.empty() works but looks awkward when the request is made

      if (displayBox.text() === "") {
        $.ajax({
          url: `/users/${user_id}/species/${species_id}.json`,
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
      text += `<a class="indented" href="/users/${garden['user_id']}/gardens/${garden['id']}"> ${garden['name']} </a> <br>`
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

    // debugger
    user_id = $(this).data().userId
    // debugger
    $.ajax({
      // debugger
      url: `/users/${user_id}/species/new`,
      method: "GET"
    })

    .then( function (data) {
      // let baseHTML = $.parseHTML(data)
      // debugger
      let baseHTML = $(data).filter("form#new_species")
      let formHTML = '<div id="species_form_container">' + baseHTML[0].outerHTML + '</div>'
      // .outerHTML()
      return formHTML
    })

    .then(function(formHTML) {
      let speciesHeader = $("#species_header")[0]
      $(formHTML).insertAfter($(speciesHeader))
      // debugger // formHTML.insertAfter("#species_header")
    })

    .then(function () {
      attachSpeciesSubmitListener()
    })

  })
}

function attachSpeciesSubmitListener() {
  $("form#new_species").submit(function(e) {
    e.preventDefault()
    // debugger
    // alert("submitted!")

    let formValues = $(this).serialize()
    // debugger
    $.ajax( {
        // debugger
        url: $(this)[0].action,
        method: $(this)[0].method.toUpperCase(),
        data: formValues
      })

    // Got to find way to handle error
    .then(function(data) {
      // debugger -- THE STATUS CODE OF 400-SOMETHING MAKES THE EXECUTION PATH JUMP
      // STRAIGH TO FAILURE

      let speciesObject = new Species(data["id"], data["name"], data["product"], data["sunlight"], data["gardens"], data["user"])

      $("#species_list").append(speciesObject.renderAbbreviatedShow())

    })

    .then(function() {
        // remove the form submitted
      $("#species_form_container").remove()
        // remove all prior event handlers to show info for the species,
        // otherwise there is a doubling bug.
      $(".species_show_link").off()
    })
    .then(function() {
      // Then reattach all listeners to the species show links, including the
      // newly created link
      attachSpeciesShowListeners()
    }).fail(function(data) {
      // let response = JSON.parse(data.responseText)
      // let errorCollection = data.responseJSON.errors
      let errorCollection = data.responseJSON.errors
      let message
      $(errorCollection).each(function(i, el) {
        message += el + ". "
      })
      debugger
      alert("Sorry, the following errors occurred:" + message)
      // $("#species_form_container").remove()
      attachSpeciesSubmitListener()
      // REMOVE DISABLED FROM SUBMIT
      // up to here
    })
  }) // end of submit call
} // end of function
