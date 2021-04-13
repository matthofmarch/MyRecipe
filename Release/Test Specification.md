US02: Login

| # | Step | Expected result |
| --- | --- | --- |
| 0 | Enter app | Go to login page (default on first open) |
| 1 | Enter Username | Email visible in cleartext |
| 2 | Enter Password | Password obscured |
| 3 | Tap login | If successful, user enters app |

US01: Registration

| # | Step | Expected result |
| --- | --- | --- |
| 0 | Enter app and tap on register | Go to register page |
| 1 | Enter Username | Email visible in cleartext |
| 2 | Enter Password | Password obscured |
| 3 | Click register | Registration takes placeIf successful, user must join or create a household |

US05: Associate household

| # | Step | Expected result |
| --- | --- | --- |
| 0 | Requesting household association | If authentication is passed, but user is in no household, household association is requested |
| 1 | Associate with household | The user will be asked to either join (US05b) or create(US05a) a household |

US05a: Join household

| # | Step | Expected result |
| --- | --- | --- |
| 0 | User joins household | User clicks join household after providing invite code |
| 1 | Associate with household | If successful, the user is being associated with his household and he enters the app to the rec |

US05b: Create household

| # | Step | Expected result |
| --- | --- | --- |
| 0 | User clicks create household | If authentication is passed, but user is in no household, household association is requested |
| 1 | Associate with household | The user will be asked to either join or create a household |

  - Nach leave household
  - Nach erstmaliger registierung

US04: Rezept hinzufügen

| # | Step | Expected result |
| --- | --- | --- |
| 0 | User wants to create a new recipe (press &quot;+&quot; Button in Recipe page) | A form for creating a new recipe pops up |
| 1 | User enters name and description | Recipe can be created |
| 2 | Optional: User adds photo | Photo is shown in preview pane |
| 3 | Optional: User specifies ingredients | Ingredients are shown in a preview list |
| 4 | User clicks save (checkmark-button in bottom right corner) | Recipe is saved and can be retrieved with all its attributes |

US03: Rezept bearbeiten

  - Ändern der zutaten
  - Bild ändern
    - Kamera
    - Galerie

| # | Step | Expected result |
| --- | --- | --- |
| 0 | User wants to edit a recipe (long press on recipe makes a bottom sheet appear. In there click the &quot;Edit&quot; option) | A form for editing an existing recipe pops up |
| 1 | User changes any of name, description, image or ingredients | Changes are shown in edit window |
| 2 | User saves recipe | Recipe is updated and can be retrieved with all its attributes (ingredients not working) |

  -

US07: Account Information and settings

| # | Step | Expected result |
| --- | --- | --- |
| 0 | User opens account information page | A page with options &quot;change email&quot;, &quot;change password&quot; and &quot;leave household&quot; appears |
| 1 | Change email:User enters a new email and submits.User gets an email to the new email address and verifies that he controls the new email address. | The email changes. |
| 2 | Change passwordEnter old and new passwordClick save | If old password is correct and new password is valid, the password gets saved |
| 3 | Change app in darkmode | App should be shown in darkmode instead in lightmode |
| 4 | Leave household:User clicks leave household | User no more belongs to his old household and must associate with any household |

US08: Weekly planner (now called Meal calendar)

  - Meal
    - Entfernen
    - Approven
    - Bottom sheet
  - Filter

| # | Step | Expected result |
| --- | --- | --- |
| 0 | User opens meal page | Meal page with calendar view opens |
| 1 | User swipes left or right | Date changes accordingly |
| 2 | User clicks current data | Datepicker opens as popup, where the user can choose the current date. The calendar view will adjust accordingly |
| 3 | User can spot accepted meals by their highlighting | Accepted meals are highlighted with a green shadow |
| 4 | Admin accepts meal in bottom sheet | Meal gets accepted, green highlighting is applied |
| 5 | Admin deletes meal | Meal is removed |
| 6 | User clicks on date | A new view appears that shows all meals for a certain day in a bigger format |

US09: Own recipes view

  - Filter attribute (not working)

| # | Step | Expected result |
| --- | --- | --- |
| 0 | User is on the recipe page and clicks opens the filter | Bottom sheet that shows quick info appears |
| 1 | Disable the checkbox that makes the app show the recipes of your fellow household&#39;s members too | Only your recipes will show now |

US10: User voting

| # | Step | Expected result |
| --- | --- | --- |
| 0 | User presses meal | Bottom sheet that shows quick info appears |
| 1 | Up/Downvote meal in bottom sheet | The meal will be up/downvoted and the up/downvote count will adjust accordingly |
| 2 | Up/Downvote meal on Voting page | The meal will be up/downvoted and the up/downvote count will adjust accordingly |
| 3 | Accept meal on Voting page | The meal will be shown as winner and on the meal calender |
| 4 | Decline meal on Voting page | The meal will be deleted from voting page |

US11: Mealplan generation //Deprecated and not desired
