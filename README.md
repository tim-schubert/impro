# impro - IMaris file PROcessing pipelines
Imaris (https://imaris.oxinst.com/) allows for statistics being exported in the form of .xls files, e.g. from surface or filament reconstructions.

## Sholl Analysis
The sholl analysis script works with Imaris statistics excel sheets from filament reconstructions. From thousands of single excel files, this script condenses the information of all animals to one summary sheet. For each animal, the mean number of intersections at each circle radius is presented. This can then be plotted, e.g. combining groups of animals with the same genotype. Statistics analysis can be performed in your preferred program - or simply in R. This script provides the foundation for that, eliminating hours of tedious copy pasting of excel sheets. 

## Conversion of .xls to .xlsx
Please convert your .xls files to .xlsx for the .R script to work. This repository includes python code to facilitate the conversion.
