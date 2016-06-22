#!/bin/bash

RESULTFILE=matches.best
ALGORITHM=FaceRecognition
target=/home/casper/repos/openbr/data/MEDS/sigset/MEDS_frontal_target.xml 
query=/home/casper/repos/openbr/data/MEDS/sigset/MEDS_frontal_query.xml
DATAPATH=/home/casper/repos/openbr/data/


if ! hash br 2>/dev/null; then
  echo "Can't find 'br'. Did you forget to build and install OpenBR?"
  exit
fi

# Define and train Eigenfaces
br -algorithm 'Open+Cvt(Gray)+Cascade(FrontalFace)+ASEFEyes+Affine(128,128,0.33,0.45)+CvtFloat+PCA(0.95):Dist(L2)' -train /home/casper/repos/openbr/data/BioID/img Eigenfaces

# Conduct experiment of Eigenfaces on MEDS

br -algorithm Eigenfaces -path /home/casper/repos/openbr/MEDS/img -compare /home/casper/repos/openbr/data/MEDS/sigset/MEDS_frontal_target.xml ../data/MEDS/sigset/MEDS_frontal_query.xml eigenfaces_meds_scores.mtx

# Extract the results of the experiemnt to CSV
br -eval eigenfaces_meds_scores.mtx Eigenfaces_MEDS.csv


# Conduct evaluation of Eigenfaces on LFW
br -algorithm Eigenfaces -path /home/casper/repos/openbr/data/LFW/img -compare /home/casper/repos/openbr/data/LFW/sigset/test_image_restricted_target.xml /home/casper/repos/openbr/data/LFW/sigset/test_image_restricted_query.xml Eigenfaces_LFW.mtx 

# Extract the results of the experiemnt to CSV format
br -eval Eigenfaces_LFW.mtx LFW.mask Eigenfaces_LFW.csv


# Conduct experiment with 4SF on MEDS
br -makeMask /home/casper/repos/openbr/data/MEDS/sigset/MEDS_frontal_target.xml /home/casper/repos/openbr/data/MEDS/sigset/MEDS_frontal_query.xml MEDS.mask

br -algorithm FaceRecognition -path /home/casper/repos/openbr/data/MEDS/img -compare /home/casper/repos/openbr/data/MEDS/sigset/MEDS_frontal_target.xml /home/casper/repos/openbr/data/MEDS/sigset/MEDS_frontal_query.xml FaceRecognition_MEDS.mtx 

# Extract the result of the experiment into CSV format

br -eval FaceRecognition_MEDS.mtx MEDS.mask FaceRecognition_MEDS.csv


# Condutct experiment with 4SF on LFW
br -algorithm FaceRecognition -path /home/casper/repos/openbr/data/LFW/img -compare /home/casper/repos/openbr/data/LFW/sigset/test_image_restricted_target.xml /home/casper/repos/openbr/data/LFW/sigset/test_image_restricted_query.xml FaceRecognition_LFW.mtx 

br -eval FaceRecognition_LFW.mtx LFW.mask FaceRecognition_LFW.csv