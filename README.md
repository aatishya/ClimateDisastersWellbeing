# ClimateDisastersWellbeing


## Overview

This repository contains the code required to replicate the empirical results in:

> *How Much Do People Care about Climate Natural Disasters?*


---

## Data

The analysis combines the following publicly available datasets:

- World Values Survey (WVS), 1990–2018  
- Geocoded Disasters (GDIS) dataset  
- Behavioral Risk Factor Surveillance System (BRFSS), 2005–2011  
- Federal Emergency Management Agency (FEMA) disaster declarations  

Raw data must be downloaded separately and stored locally. They are not included in this repository.

---

## Repository Structure
```
├── 1_processing_wvs.do
├── 2_processing_brfss.do
├── 3_reg_codes.do
├── License
├── README.md
└──wvs-gadm_match.xlsx
```

### File Descriptions

**1_processing_wvs.do**  
Cleans World Values Survey data, constructs wellbeing measures, and matches disaster events to sub-national regions.

**2_processing_brfss.do**  
Processes U.S. BRFSS data and constructs disaster variables.

**3_reg_codes.do**  
Runs the regressions and produces the main tables reported in the paper.

**wvs-gadm_match.xlsx**  
Provides the crosswalk between World Values Survey sub-national regions and GADM administrative boundaries used to match disaster events to survey respondents.

---

## Replication Instructions

### Step 1: Download Raw Data

Download the WVS, GDIS, BRFSS, and FEMA datasets from their respective public sources.  
Place the raw data files in a local directory and adjust file paths in the `.do` files accordingly.

---

### Step 2: Process WVS Data

In Stata, run:

do 1_processing_wvs.do


---

### Step 3: Process BRFSS Data

Run:
do 2_processing_brfss.do


---

### Step 4: Run Main Regressions

Run:
do 3_reg_codes.do



This will reproduce the cross-national and U.S. regression tables reported in the paper.

---


## Data Availability

All datasets used in this study are publicly available from:

- World Values Survey  
- NASA SEDAC (GDIS)  
- CDC (BRFSS)  
- FEMA  

---

## Contact and issues
For questions or comments, please contact aatishya.mohanty@abdn.ac.uk and c.k.tang@ntu.edu.sg.
