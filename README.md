# Cities Search App

## Approach

	1.	Asynchronous Data Loading: Cities data is fetched asynchronously to ensure a smooth user experience. The loadData method handles API requests.
	2.	Data Modeling: CityModel represents city data with attributes such as name, country, and favorite status.
	3.	Filtering & Sorting:
	•	Filter: Cities are filtered based on search text and favorite status.
	•	Sort: Results are sorted alphabetically by city name and then by country.
	4.	Combine Framework:
Combine is used to automatically update the UI when search text, city list, or favorite status changes. Filtering and sorting operations are done in filterCities.

# Areas to improve

	•	Data Size: The current approach assumes a manageable volume of city data. Pagination might be needed. Alternative use core data to save the cities array? And retrieving it with predicates. 
	•	Performance: Initial performance is suitable, but further optimization may be required.

## Project Structure

	•	UIKit & SwiftUI Integration: The project starts with UIKit for core functionalities and navigation handlings, while SwiftUI is used for modern view components.
        •	Models: CityModel and CoordinateModel.
	•	ViewModels: Manages data loading and filtering (CitiesViewModel).
	•	Views: Displays city information.
	•	Tests: Unit tests for functionality verification. Todo UI test cases.
