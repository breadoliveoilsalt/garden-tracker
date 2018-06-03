
$(window).load(function() {
  attachGardensLinkListener()
})

function attachGardensLinkListener() {

  $('#view_gardens_link').on('click', function(e) {
    e.preventDefault()

    let userId = $(this).data().userId

    $.ajax({
      url: `${userId}/gardens.json`,
      method: `GET`
    })
    .then(function (response) {

        // No need to import Garden class from other file
        // b/c all the files are loaded together //

      let htmlToInsert = `

        <h2> Your Gardens: </h2>
        <ul>
      `

      for (var data of response) {

          let gardenObject = new Garden(data["id"], data["name"], data["description"], data["square_feet"], data["user_id"], data["user"], data["species"], data["plantings"])

          htmlToInsert += "<li>" + gardenObject.renderGardenListItem() + "</li>"


      }

      htmlToInsert += `
        </ul>

        <h2> <a href="/gardens/new">Add a Garden</a> </h2>
      `

      $("#gardens_container")[0].innerHTML = htmlToInsert

    })
  })

}
