$(function () {
  attachAddPlantingLinkListener()
})

function attachAddPlantingLinkListener() {
  $("#add-planting-link").on("click", displayNewPlantingForm)
}

function displayNewPlantingForm() {
  alert("Link clicked!")
}
