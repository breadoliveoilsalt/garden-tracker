// add listener to #view_gardens_link
// the listener will then have a function
// that gets the ajax request, and replaces
// the link words with a list of the user's
// gardens.
// Have to format controller too...do I have respond_to for json vs html?


// $(function() {
//   attachGardensLinkListener()
// })

// import {Garden} from './gardens_for_gardens_show_page'

$(window).load(function() {
  attachGardensLinkListener()
})

function attachGardensLinkListener() {

  $('#view_gardens_link').on('click', function(e) {
    e.preventDefault()

    user_id = $(this).data().userId

    $.ajax({
      url: `${user_id}/gardens.json`,
      method: `GET`
    })
    .then(function (response) {

        // No need to import Garden class from other file
        // b/c all the files are loaded together

      let htmlToInsert

      for (var data of response) {

          gardenObject = new Garden(data["id"], data["name"], data["description"], data["square_feet"], data["user_id"], data["user"], data["species"], data["plantings"])

          debugger

      }

    })
  })

}
