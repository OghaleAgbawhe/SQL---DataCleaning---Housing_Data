# SQL-DataCleaning- Housing_Data

Welcome to my Housing Data Cleaning Project! This project focuses on utilizing SQL queries to clean and enhance the "NashvilleHousing" dataset, which contains housing information for Nashville. The goal is to transform raw data into a more structured and usable format.

## Project Overview
The dataset required several data cleaning steps to ensure accuracy and consistency. The primary cleaning tasks are outlined below:

Standardizing Date Format: The SaleDate column had inconsistent date formats. SQL queries were used to standardize the date format and create a new column named SaleDateConverted.

Populating Null Property Addresses: Records with null PropertyAddress values were identified and populated by matching corresponding ParcelID values.

Dividing 'PropertyAddress' into Individual Fields: The PropertyAddress column was split into separate columns for Address and City.

Cleaning 'OwnerAddress' Field: The OwnerAddress column was split into separate columns for Address, City, and State using the PARSENAME function.

Cleaning the 'SoldAsVacant' Field: The values in the SoldAsVacant field were standardized to 'Yes' and 'No'.

Handling Duplicates: Duplicate records were identified and removed based on multiple columns using a Common Table Expression (CTE) and the ROW_NUMBER window function.

Deleting Unused Columns: Unused columns such as OwnerAddress, TaxDistrict, PropertyAddress, and SaleDate were dropped from the dataset.

# Skills Showcased
Throughout this project, the following SQL skills were showcased:

Data cleaning using SQL queries
Data transformation and manipulation
Handling null values
String manipulation using functions like SUBSTRING, PARSENAME, and REPLACE
Standardizing and converting data values
Identifying and handling duplicates
Dropping columns from a table


To explore the cleaning process in detail, kindly refer to the SQL queries provided in this repository. Each query is well-documented to explain the purpose and steps taken for data cleaning.

This project demonstrates the power of SQL queries in transforming messy and inconsistent data into structured, usable information. Through data cleaning, manipulation, and transformation, this project contributes to making data-driven decisions more accurate and insightful.
