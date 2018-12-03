
// Note that these two:
  // $(window).load(function() { //
  // $(document).ready()
    // ... would not work due to turbolinks v5 issue
    // When turbolinks was active, this would work in garden.js, button
    // not species.js:
      // $(document).on('turbolinks:load', function() {} etc.

$(function () {
  attachGardenButtonListeners()
})
// Try this later:
// (function () {
//   attachGardenListeners()
// })()

function attachGardenButtonListeners() {

  $("#next_garden_button").on("click", {param1: "next"}, getGardenInfo)
  $("#previous_garden_button").on("click", {param1: "previous"}, getGardenInfo)
}

function getGardenInfo(event) {
    event.preventDefault()

    const userId = event.target.dataset.userId
    const gardenId = event.target.dataset.gardenId
    const urlRequest = `/users/${userId}/gardens/${gardenId}/` + event.data.param1

    $.ajax({
          // Get the json representing the ids of a user's gardens
        url: urlRequest,
        method: "GET"
      })
          // Create an "instance" of the gardenObject
      .then(function(data) {
        const gardenObject = new Garden(data["id"], data["name"], data["description"], data["square_feet"], data["active"], data["user_id"], data["user"], data["species"], data["plantings"])
          // Render information for gardenObject as "insert"
        const insert = gardenObject.renderGardenShow()
        return insert
      })
        // Insert the "insert" into the DOM at the garden_display container
      .then(function(insert) {
        // For some reason, jQuery will not work: $("#garden-container").html(insert)
        document.getElementById("garden-container").innerHTML = insert
        // Have to attachGardenListeners b/c button is being rendered anew with the axaj call
        attachGardenButtonListeners()
      })
      .fail(function(jqXHR, textStatus) {
        console.log("There was an error: ", textStatus)
        alert("Sorry, there was an error. Please try something else.")
      })
    }

class Garden {
  constructor(id, name, description, squareFeet, active, userId, user, species, plantings) {
    this.id = id
    this.name = name
    this.description = description
    this.squareFeet = squareFeet
    this.active = active
    this.userId = userId
    this.user = user
    this.species = species
    this.plantings = plantings
  }

  renderGardenShow() {

    let htmlToInsert = `
        <div>

        <h1 class="underlined"> ${this.name}</h1>

        <div class="ui four item menu stackable show-menu" id="garden-button-display">
          <p class="sub-menu-item"><button name="button" type="submit" id="previous_garden_button" data-garden-id="${this.id}" data-user-id="${this.userId}" class="ui button tiny wide-spacing">&lt;&lt; Jump to Prior Garden Created</button></p>

          <p class="sub-menu-item bold"> <a href="/users/${this.userId}/gardens/${this.id}/edit">Edit/Update</a> </p>
          <p class="sub-menu-item bold"> <a data-confirm="Are you sure you want to delete this garden (and all of its plantings)?" rel="nofollow" data-method="delete" href="/users/${this.userId}/gardens/${this.id}">Delete</a> </p>

          <p class="sub-menu-item"><button name="button" type="submit" id="next_garden_button" data-garden-id="${this.id}" data-user-id="${this.userId}" class="ui button tiny wide-spacing">Jump to Next Garden Created &gt;&gt;</button></p>
        </div>


        <div class="ui divider divider-spacer"></div>

        <h2> Currently Active: ${ this.active ? "Yes" : "No"} </h2>

        <div class="ui divider divider-spacer"></div>

        <h2> Square Feet: ${this.squareFeet} </h2>

        <div class="ui divider divider-spacer"></div>

        <h2> Description: </h2>

        <div class="ui container text">
          <h3> ${this.description} </h3>
        </div>

        `

      htmlToInsert += this.renderPlantingsTable()

      return htmlToInsert

  }


  renderPlantingsTable() {
    let htmlToInsert = `
        <div class="ui divider divider-spacer"></div>

        <h2> Plantings: </h2>

        <table class="ui celled table center aligned">
                        <thead>
                          <tr>
                            <th> Name </th>
                            <th> Quantity </th>
                            <th> Date Planted </th>
                            <th> Harvested </th>
                            <th> Expected Maturity Date </th>
                          </tr>
                        </thead>
                        <tbody>
                        `
    if (!this.plantings.length) {
      htmlToInsert += `
                          <tr>
                            <td colspan="5">None.</td>
                          </tr>
                          `
    }
    else {

      for (let planting of this.plantings) {

        let datePlantedString
        let dateHarvestedString
        let maturityDateString

        let datePlantedObject = new Date(planting.date_planted)
        let datePlantedMonth = this.checkValue((datePlantedObject.getUTCMonth() + 1).toString())
        let datePlantedDay = this.checkValue(datePlantedObject.getUTCDate().toString())
        let datePlantedYear = datePlantedObject.getFullYear().toString()
        datePlantedString = datePlantedMonth + "/" + datePlantedDay + "/" + datePlantedYear

        if (!planting.date_harvested) {
          dateHarvestedString = "No"
        } else {
          let dateHarvestedObject = new Date(planting.date_harvested)
          let dateHarvestedMonth = this.checkValue((dateHarvestedObject.getUTCMonth() + 1).toString())
          let dateHarvestedDay = this.checkValue(dateHarvestedObject.getUTCDate().toString())
          let dateHarvestedYear = dateHarvestedObject.getFullYear().toString()
          dateHarvestedString = dateHarvestedMonth + "/" + dateHarvestedDay + "/" + dateHarvestedYear
        }


        if (planting.date_harvested) {
          maturityDateString = "Harvested"
        } else if (planting.expected_maturity_date) {
          let maturityDateObject = new Date(planting.expected_maturity_date)
          let maturityDateMonth = this.checkValue((maturityDateObject.getUTCMonth() + 1).toString())
          let maturityDateDay = this.checkValue(maturityDateObject.getUTCDate().toString())
          let maturityDateYear = maturityDateObject.getFullYear().toString()
          maturityDateString = maturityDateMonth + "/" + maturityDateDay + "/" + maturityDateYear
        } else {
          maturityDateString = "Not Available"
        }

        htmlToInsert += `
                          <tr>

                            <td> ${planting.name} </td>
                            <td> ${planting.quantity} </td>
                            <td> ${datePlantedString} </td>
                            <td> ${dateHarvestedString} </td>
                            <td> ${maturityDateString} </td>
                          </tr>
                          `
      }

    }

      htmlToInsert += `                      </tbody>

                          </table>
          `

      return htmlToInsert

  }

    // If the Rails server returns a day or month represented by 1 digit, the
    // html reads as "01", "02", etc.  However, the ajax request will return just
    // "1", "2", etc.  checkValue is here to eliminate this discrepency.  
  checkValue(value) {
    return value.length === 1 ? "0" + value : value
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
