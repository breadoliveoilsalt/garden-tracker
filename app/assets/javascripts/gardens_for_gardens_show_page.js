
// Note that these two:
  // $(window).load(function() { //
  // $(document).ready()
    // ... would not work due to turbolinks v5 issue
    // When turbolinks was active, this would work in garden.js, button
    // not species.js:
      // $(document).on('turbolinks:load', function() {} etc.

$(function () {
  attachGardenListeners()
})
// Try this later:
// (function () {
//   attachGardenListeners()
// })()

function attachGardenListeners() {

  $("#next_garden_button").on("click", function(e) {
    e.preventDefault()

    const userId = e.target.dataset.userId
    const gardenId = e.target.dataset.gardenId

    $.ajax({
          // Get the json representing the ids of a user's gardens
        url: `/users/${userId}/gardens/${gardenId}/next`,
        method: "GET"
      })
          // Create an "instance" of the gardenObject
      .then(function(data) {
        debugger
        const gardenObject = new Garden(data["id"], data["name"], data["description"], data["square_feet"], data["user_id"], data["user"], data["species"], data["plantings"])

          // Replace button's data of garden id with gardenObject's id, so that
          // next time the button is pressed, the next garden is retreived.

        $("#next_garden_button").attr("data-garden-id", gardenObject.id)

          // Render information for gardenObject as "insert"
        const insert = gardenObject.renderGardenShow()

        return insert
      })
        // Insert the "insert" into the DOM at the garden_display container
      .then(function(insert) {
        $(`#garden_display`).html(insert)
      })
  })
}

class Garden {
  constructor(id, name, description, squareFeet, userId, user, species, plantings) {
    this.id = id
    this.name = name
    this.description = description
    this.squareFeet = squareFeet
    this.userId = userId
    this.user = user
    this.species = species
    this.plantings = plantings
  }

  renderGardenShow() {

    let htmlToInsert = `
            <h1>${this.name} </h1>

                  <h2>
                    <a href="/gardens/${this.id}/plantings/new">Add a Planting</a> |
                    <a href="/gardens/${this.id}/edit">Edit Garden</a> |
                    <a data-confirm="Are you sure you want to delete this garden?" rel="nofollow" data-method="delete" href="/gardens/${this.id}">Delete Garden</a>
                </h2>


            <h2> Creater: <a href="/users/${this.userId}/gardens">${this.user.name}</a></h2>

            <h2> Description: ${this.description} </h2>

            <h2> Square Feet: ${this.squareFeet}</h2>

        `

      htmlToInsert += this.renderPlantings()

      return htmlToInsert

  }

  renderPlantings() {
    let htmlToInsert = `
        <h3> Plantings: </h3>

          <ul>
      `

    for (var x of this.plantings) {

      htmlToInsert += `
        <li> <a href="/users/${x.user_Id}/species/${x.species_id}">${x.name}</a> </li>
          <ul>
            <li> Quantity: ${x.quantity} </li>
          </ul>
        `
    }

      htmlToInsert += "</ul>"

      return htmlToInsert

  }

  renderGardenListItem() {
    return `
      ${this.name} |
      <a href="${this.userId}/gardens/${this.id}">Garden Details</a> |
      <a href="/gardens/${this.id}/plantings/new">Add a Planting</a> |
      <a href="/gardens/${this.id}/edit">Edit Garden</a> |
      <a data-confirm="Are you sure you want to delete this garden?" rel="nofollow" data-method="delete" href="/gardens/${this.id}">Delete Garden</a>
    `
  }

}
