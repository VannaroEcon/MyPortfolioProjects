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
