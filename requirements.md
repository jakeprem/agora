# Widget Marketplace Task

Write a marketplace application where users can buy and sell widgets.

## Core Functions
- Users must be able to create an account. Users can perform both roles, seller (who adds a widget) and buyer (who purchases the widget);
- Users can add a widget for sale;
- When a user purchases a widget, the price of the widget is credited to the original seller’s account minus the 5% marketplace fee, and debited from the buyers account;
- If a buyers account has a balance of $0, they cannot purchase any more widgets until they either sell some themselves, or deposit more money;

## Data Models

You can extend these models or create new ones:

### User
- first_name
- last_name
- email

### Widget
- seller
- description
- price

### Transaction
- seller
- buyer
- widget

## Others

 - This project does not require a web interface, but you can add one if you desire
 - Document all design decisions and technology choices;
 - If you use any external dependency in your application, explain why;
 - Document any assumptions made when writing the application
 - Include instructions on how to run the application and how to run the test suite.