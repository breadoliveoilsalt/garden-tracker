// add listener to #view_gardens_link
// the listener will then have a function
// that gets the ajax request, and replaces
// the link words with a list of the user's
// gardens.
// Have to format controller too...do I have respond_to for json vs html?


// $(function() {
//   attachGardensLinkListener()
// })

$(window).load(function() {
  attachGardensLinkListener()
})

function attachGardensLinkListener() {

  $('#view_gardens_link').on('click', function(e) {
    e.preventDefault()
    alert("yo!")
  })

}
