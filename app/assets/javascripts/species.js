let user_id

$(function () {
  attachSpeciesShowListener()
  attachSpeciesNewFormListener()
})


function attachSpeciesShowListener() {
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
          let speciesObject = new Species(data["name"], data["product"], data["sunlight"], data["gardens"])
          displayBox.append(speciesObject.renderShow())
        }).fail(function() {
          displayBox.append("Sorry, there was an error.")
        })
      }
   }) // end of .on("click")
}

class Species {
  constructor(name, product, sunlight, gardens) {
    this.name = name
    this.product = product
    this.sunlight = sunlight
    this.gardens = gardens
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
      // `<a href="/users/${garden['user_id']}/gardens/${garden['id']}"> garden['name'] </a> <br>`

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
    alert("submitted!")
  })
}
  //   let formValues = $(this).serialize()
  //   debugger
  //
  //   $.ajax( {
  //     // debugger
  //     url: `users/${user_id}/species/new`,
  //     method: "POST",
  //     data: formValues
  //   })
  //   .then(function(response) {
  //       debugger
  //   })
  //
  // })
// }
  // $("#species_submit").on("click", function(e) {
  //   e.preventDefault()
  //   alert("Species submitted!")
  // })
// }
