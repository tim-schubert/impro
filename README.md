# impro - IMaris file PROcessing pipelines
Imaris (https://imaris.oxinst.com/) allows for statistics being exported in the form of .xls files, e.g. from surface or filament reconstructions.

## Conversion of .xls to .xlsx
Please first convert your .xls files to .xlsx for the .R script to work. This repository includes python code to facilitate the conversion.

## Sholl analysis from filament reconstructions
The sholl analysis script works with Imaris statistics excel sheets from filament reconstructions. From thousands of single excel files, this script condenses the information of all animals to one summary sheet. For each animal, the mean number of intersections at each circle radius is presented. This can then be plotted, e.g. combining groups of animals with the same genotype. Statistics analysis can be performed in your preferred program - or simply in R. This script provides the foundation for that, eliminating hours of tedious copy pasting of excel sheets. 

## Mean area and volume from surface reconstructions
This script calculates mean area and volume values per individual.

## Spot count summary
This script allows users to summarize spot counts from multiple Spot reconstructions per individual sample.

# Citation
When using impro, please cite https://doi.org/10.1101/2025.06.10.658830.

