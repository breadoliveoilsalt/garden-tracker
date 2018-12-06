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
    $("#new-planting-container")[0].innerHTML = newPlantingForm
  })
}
