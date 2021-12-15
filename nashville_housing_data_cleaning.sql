/*

Nashville Housing Data Cleaning in SQL Queries

*/


Use PortfolioProject
Go


--------------------------------------------------------------------------------------

-- Check the tables

Select * 
From dbo.nashvillehousing



--------------------------------------------------------------------------------------

-- Standardize the Date Format

ALTER TABLE nashvillehousing
Add SaleDateConverted Date;

Update nashvillehousing
SET SaleDateConverted = CONVERT(Date, SaleDate)



--------------------------------------------------------------------------------------

-- Populate Property Address

Select *
From dbo.nashvillehousing
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From dbo.nashvillehousing a
JOIN dbo.nashvillehousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From dbo.nashvillehousing a
JOIN dbo.nashvillehousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null



