
let userId
let userGardenIds
let userGardenIdsLength
let indexOfCurrentGarden
let counter = 0


$(function() {
  getUserGardensIds()
  // attachGardenListeners()
})


function getUserGardensIds() {
  userId = $(".next_garden_button").data().userId

  $.ajax({
        // Get the json representing the ids of a user's gardens
      url: `/users/${userId}/get_garden_ids`,
      method: "GET"
    })

        // Turn the json response into an array of the gardens ids
    .then(function(data){
      let arr = []
      $(data).each(function (index, element){
        arr.push(element["id"])
      })
      userGardenIds = arr
      return arr
    })
    .then(function(arr) {
      userGardenIds = arr
      debugger
    })

}
  // A user's gardens will necessarily have ids in numerical order (e.g., a user's
  // gardens might be ids 2, 5, 7, 15).  So the first step in rendering a ajax request
  // is, on the first request, get all of the ids of the users gardens, to be an array
  // of user_garden_ids.  Then, on the subsequent ajax requests, the request will cycle
  // through this array to pull up the user's next garden.

  // NO: this is actually how to do it:  when the document loads, get the array of garden_ids;
  // once it is there, then you can add the button!  That way I have it once, and the ajax request
  // can still happen



// This is getting too complicated.
// Everytime: fetch the ids of the user's garden
// Then see where we are in the list
// Then advance to the next element in the list
// Then bring that up

// function attachGardenListeners() {
//   $(".next_garden_button").on("click", function(e) {
//
//         // not sure if i need this:
//       e.preventDefault()
//
//       let userId = $(this).data().userId
//       let gardenId = $(this).data().gardenId
//       let displayBox = $("#garden_display_id_" + gardenId)
//
//
//
//         .then(function(arr) {
//           // make a function to test if current gardenId is the last element
//           // in the array. If so, then modify button to go back to beginning
//           // and add html.  If no, then modify the data of the button and
//           // add the html
//         })
//        })}
//           // return makeIdArray(data)
//
//           // indexOfCurrentGarden = getIndex(gardenId)


      // fetch(`/users/${userId}/get_garden_ids`)
      //   .then(function(data) {
      //     console.log(data)
      //     debugger
      //   }

          // function(data) {
          // return data.json()
        // )
        // .then(function(jsonResp){
        //   console.log(jsonResp)
        // })
//
//   })
// }

      //
      //
      // if (!userGardenIds) {
      //   userGardenIds = getUserGardensIds(userId)
      //   userGardenIdsLength = userGardenIds.length
      //   debugger
      //
      //   // The execution is getting here, but not running the function until it gets passed it.
      // }

      // if (!userGardenIds) {
      //   debugger
      //   getUserGardensIds(userId)
      //   // The execution is getting here, but not running the function until it gets passed it.
      // }
      // debugger


            // let speciesObject = new Species(data["name"], data["product"], data["sunlight"], data["gardens"])
        //     displayBox.append(speciesObject.renderShow())
        //   }).fail(function() {
        //     displayBox.append("Sorry, there was an error.")
        //   })







// function makeIdArray(data) {
//   let arr = []
//   $(data).each(function (index, element){
//     arr.push(element["id"])
//   })
//   return arr
// }

function getIndex(gardenId) {
  debugger
  $(userGardenIds).each( function (i, e) {
    if (e === gardenId) {
      return i
    }
  })

}
      // I could get all of the gardens and then cycle through them one at a time
      // I could make a ajax request to a new route...which would return all of the ids of the gardens.  Then make a second ajax request for the garden.

      //
      //   // To prevent duplication of data insert in event user clicks on link twice.
      //   // displayBox.empty() works but looks awkward when the request is made
      //
      // if (displayBox.text() === "") {
      //   $.ajax({
      //     url: `/users/${user_id}/species/${species_id}.json`,
      //     method: "GET"
      //   }).done(function(data){
      //     let speciesObject = new Species(data["name"], data["product"], data["sunlight"], data["gardens"])
      //     displayBox.append(speciesObject.renderShow())
      //   }).fail(function() {
      //     displayBox.append("Sorry, there was an error.")
      //   })
      // }
//    }) // end of .on("click")
// }

// class Species {
//   constructor(name, product, sunlight, gardens) {
//     this.name = name
//     this.product = product
//     this.sunlight = sunlight
//     this.gardens = gardens
//   }
//
//   renderShow() {
//     let gardens = $(this.gardens)
//     return `
//       Product: ${this.product} <br>
//       Sunlight: ${this.sunlight} <br>
//       Your Gardens Where This Appears: <br> ${this.renderGardens(gardens)}
//       `
//   }
//
//   renderGardens(gardens) {
//       // Note that gardens here is jQuery object
//     let text = ""
//
//     gardens.each(function(index, garden) {
//       text += `<a class="indented" href="/users/${garden['user_id']}/gardens/${garden['id']}"> ${garden['name']} </a> <br>`
//     })
//
//     return text
//       // `<a href="/users/${garden['user_id']}/gardens/${garden['id']}"> garden['name'] </a> <br>`
//
//   }
// }
//

// make sure to note that data on garden will change
// I'll need to find next garden
