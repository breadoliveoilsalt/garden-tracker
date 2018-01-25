# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(name: "Tommy", password: "tommytommy")

User.create(name: "Betty", password: "bettybetty")

Garden.create(name: "Backyard", description: "Pretty shady back there", square_feet: 50) #garden_id: 1

Garden.create(name: "Front Yard", description: "Sunny but small", square_feet: 20) #garden_id: 2

#####

Species.create(name: "Tomato", product: "vegetable", sunlight: "full-sun")

GardenSpecies.create(garden_id: 1, species_id: 1) # Backyard has tomatoes

Species.create(name: "Grapes", product: "fruit", sunlight: "part-shade")

GardenSpecies.create(garden_id: 2, species_id: 2) # Front yard has grapes

Species.create(name: "Hosta", product: "non-edible", sunlight: "shade")

GardenSpecies.create(garden_id: 1, species_id: 3) # Backyard has hostas

Species.create(name: "Basil", product: "herb", sunlight: "full-sun")

GardenSpecies.create(garden_id: 2, species_id: 4) # Front yard has grapes

######

Planting.create(quantity: 4, garden_id: 1, species_id: 1) # 4 tomatoes in Backyard

Planting.create(quantity: 2, garden_id: 2, species_id: 2) # 2 grapes in Front Yard

Planting.create(quantity: 6, garden_id: 1, species_id: 3) # 6 hostas in Backyard

Planting.create(quantity: 10, garden_id: 2, species_id: 4) # 10 basil plants in Front Yard
