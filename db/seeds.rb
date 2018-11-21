# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(name: "Tommy", password: "tommytommy")

User.create(name: "Betty", password: "bettybetty")

#####

Garden.create(name: "Backyard", description: "Pretty shady back there", square_feet: 50, user_id: 1) #garden_id: 1

Garden.create(name: "Front Yard", description: "Sunny but small", square_feet: 20, user_id: 1) #garden_id: 2

Garden.create(name: "Raised Beds", description: "Sunny, good drainage", square_feet: 8, user_id: 2) #garden_id: 3

#####

Species.create(name: "Tomato", category: "vegetables", sunlight: "full-sun", user_id: 1, days_to_maturity: 90)

SpeciesGarden.create(garden_id: 1, species_id: 1) # Tommy's Backyard has tomatoes

Species.create(name: "Grapes", category: "fruits", sunlight: "part-shade", user_id: 1)

SpeciesGarden.create(garden_id: 2, species_id: 2) # Tommy's Front yard has grapes

Species.create(name: "Hosta", category: "non-edible", sunlight: "shade", user_id: 1)

SpeciesGarden.create(garden_id: 1, species_id: 3) # Tommy's Backyard has hostas

Species.create(name: "Basil", category: "herbs", sunlight: "full-sun", user_id: 1, days_to_maturity: 30)

SpeciesGarden.create(garden_id: 2, species_id: 4) # Tommy's Front yard has grapes

######

Planting.create(quantity: 4, garden_id: 1, species_id: 1, user_id: 1, date_planted: "2018-11-20") # 4 tomatoes in Tommy's Backyard

Planting.create(quantity: 2, garden_id: 2, species_id: 2, user_id: 1) # 2 grapes in Tommy's Front Yard

Planting.create(quantity: 6, garden_id: 1, species_id: 3, user_id: 1) # 6 hostas in Tommy's Backyard

Planting.create(quantity: 10, garden_id: 2, species_id: 4, user_id: 1, date_planted: "2018-07-01", date_harvested: "2018-08-30") # 10 basil plants in Tommy's Front Yard

Planting.create(quantity: 15, garden_id: 1, species_id: 4, user_id: 1, date_planted: "2018-12-20")
