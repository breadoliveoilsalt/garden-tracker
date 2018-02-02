# Specifications for the Rails Assessment

Specs:
- [x] Using Ruby on Rails for the project

- [x] Include at least one has_many relationship (x has_many y e.g. User has_many Recipes)
      - In the Garden model, a garden has_many species and has_many plantings.

- [x] Include at least one belongs_to relationship (x belongs_to y e.g. Post belongs_to User)
      - Each instance of a Garden, Species, and Planting object belongs_to a user; also, a Planting
          instance belongs_to a Garden and a Species.


- [x] Include at least one has_many through relationship (x has_many y through z e.g. Recipe has_many Items through Ingredients)
      - A Garden has_many Species, and Species has_many Gardens, through a SpeciesGarden join table/

- [x] The "through" part of the has_many through includes at least one user submittable attribute (attribute_name e.g. ingredients.quantity)
      - As examples: for a Garden, a user is able to input the name and square_feet; for a Species, a user
          is able to input a name and its type (vegetable, fruit, etc.)

- [x] Include reasonable validations for simple model objects (list of model objects with validations e.g. User, Recipe, Ingredient, Item)
      - All of the models take advantage of the "validates" macro.

- [x] Include a class level ActiveRecord scope method (model object & class method name and URL to see the working feature e.g. User.most_recipes URL: /users/most_recipes)
    - The Garden model has class level methods for showing the Garden with the largest square footage and
        the Garden with the most plantings.

- [x] Include a nested form writing to an associated model using a custom attribute writer (form URL, model name e.g. /recipe/new, Item)
    - When a user creates a garden (gardens/new view), the user can chose to add an initial Planting.
        This depends on a custom writer ("planting_attributes=") in the Garden model.
    - If the user has added Plantings to a Garden, the user has the ability to edit the plantings
        in the gardens/edit view.  This depends on a custom updater ("custom_updater_for_nested_params")
        in the Garden model.


- [x] Include signup (how e.g. Devise)
    - Handled without Devise using the has_secure_password macro and the UsersController.

- [x] Include login (how e.g. Devise)
    - Handled through the SessionsController.

- [x] Include logout (how e.g. Devise)
    - Handled without Devise through the SessionsController.

- [x] Include third party signup/login (how e.g. Devise/OmniAuth)
    - Users can sign in through GitHub.  This relies on OmniAuth.  See User model's User.create_user_from_github
      and SessionsController #create_from_github.

- [x] Include nested resource show or index (URL e.g. users/2/recipes)
    - The routes allow for routes such as users/1/gardens and users/1/species/1.

- [x] Include nested resource "new" form (URL e.g. recipes/1/ingredients)
    - The routes allow for gardens/1/plantings/new.

- [x] Include form display of validation errors (form URL e.g. /recipes/new)
    - Validation error appear on forms for creating instances of various objects (e.g., User, Garden, etc.)

Confirm:
- [ ] The application is pretty DRY
- [ ] Limited logic in controllers
- [ ] Views use helper methods if appropriate
- [ ] Views use partials if appropriate
