
-- CLEANING DATA UTILIZING SQL QUERIES 

Select * 
from PortfolioProject.dbo.NashvilleHousing

------------------------------------------------------------------------------------------------------

--Standardizing the date format 

Select SaleDate
from PortfolioProject.dbo.NashvilleHousing

-- Creating a new column for the cleaned date 

ALTER Table NashvilleHousing
Add SaleDateConverted Date;

--Updating the table and filling new column with Date format instead of previous datetime format 

Update PortfolioProject.dbo.NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)


------------------------------------------------------------------------------------------------------

--POPULATING THE NULL PROPERTY ADDRESS FIELD

--Obtaining the null PropetyAddress records for cleaning 
Select *
From PortfolioProject.dbo.NashvilleHousing
where PropertyAddress is null

---Begin by assessing/determining what can be linked with Property Address

Select *
From PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
Order by ParcelID

--Upon investigation, it was observed that the same ParcelID's have the same Property Addresses
--Hence, I will populate missing/null PropertyAddresses, with the addresses of the corresponding Parcel ID's 
--Records with same Parcel ID's can however be distinguished using the Unique ID field

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--Updating/Populating the null Property Addresses 

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

------------------------------------------------------------------------------------------------------

--Dividing the 'PropertyAddress' into Individual fields namely Address, City, State utilizing Substring

Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing

--Separating the data using the substring command with comma(,) as the common delimiter
SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address,
SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS City
From PortfolioProject.dbo.NashvilleHousing

--Upon separating values from one column, use it to create two other columns for Address and city 
ALTER Table PortfolioProject.dbo.NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) 


ALTER Table PortfolioProject.dbo.NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) 

Select *
From PortfolioProject.dbo.NashvilleHousing


-----------------------------------------------------------------------------------------------------------------------


--CLEANING/SPLITTING THE 'OWNERADDRESS' into Individual fields namely Address, City, State utilizing PARSENAME

Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing

Select 
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
, PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
, PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject.dbo.NashvilleHousing


--Adding new columns for the Address, City and State 

ALTER Table PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

ALTER Table PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

ALTER Table PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(255);

--Populating/Updating the new fields with the cleaned Address, City and State

Update PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

Update PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitCity =  PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

Update PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


Select *
From PortfolioProject.dbo.NashvilleHousing


------------------------------------------------------------------------------------------------------

--CLEANING THE "SoldAsVacant" FIELD

-- Checking data in 'Sold as Vacant' column 

Select DISTINCT(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing

--Counting the Unique fields

Select Distinct (SoldAsVacant), count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2

--Changing Y AND N to Yes and No in the "Sold as Vacant" Field for consistency purposes 

Select SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject.dbo.NashvilleHousing

UPDATE PortfolioProject.dbo.NashvilleHousing 
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

---Confimation of update 

Select Distinct (SoldAsVacant), count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2

------------------------------------------------------------------------------------------------------
--HANDLING DUPLICATES 

--Using CTE and windows function to find out duplicate values 
---Partitionining the data using Row_number to see the duplicates

WITH RowNumCTE AS (
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY 
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing
)

Select *
From RowNumCTE
where row_num > 1
Order by PropertyAddress


---Deleting the duplicates

WITH RowNumCTE AS (
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY 
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing
)

DELETE
From RowNumCTE
where row_num > 1


------------------------------------------------------------------------------------------------------
---DELETING UNUSED COLUMNS

Select *
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate 
