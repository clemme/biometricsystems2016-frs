#!/bin/bash

RESULTFILE=matches.best
ALGORITHM=FaceRecognition
target=/home/casper/repos/openbr/data/MEDS/sigset/MEDS_frontal_target.xml 
query=/home/casper/repos/openbr/data/MEDS/sigset/MEDS_frontal_query.xml
DATAPATH=/home/casper/repos/openbr/data/


if ! hash br 2>/dev/null; then
  echo "Can't find 'br'. Did you forget to build and install OpenBR? Here's some help: http://openbiometrics.org/doxygen/latest/installation.html"
  exit
fi


function enrollFaces {
	echo "Enrolling faces"
	br -algorithm ${ALGORITHM} -enrollAll -enroll $1 -path $2 'meds.gal'
}

function enrollFromWebcam {
	echo "Enrolling the webcam"

	br -algorithm ${ALGORITHM} -enrollAll -enroll 0.webcam 'webcam.gal'
}

function webcam {
	br -gui -algorithm "Open+Cvt(Gray)+Cascade(FrontalFace)+ASEFEyes+Affine(128,128,0.33,0.45)+CvtFloat+PCA(0.95)+Draw(lineThickness=3)+Show(false)" -enroll 0.webcam
}

function testPrope {
	# -compare meds.gal ../../openbr/data/MEDS/img/S001-01-t10_01.jpg match_scores.csv
	echo "Testing"
	br -algorithm ${ALGORITHM} -enrollAll -enroll $1 target.gal

	br -algorithm ${ALGORITHM} -compare meds.gal target.gal score.csv

	echo "Evaluating"
	#br -eval scores.mtx e.csv

	echo "plotting "

	# Create plots
	#br -plot e.csv plot.pdf
	echo "plotted to plot.pdf"
	
}

function performLfwBench {
	br -makeMask $target $query MEDS.mask


	# Run Algorithm on MEDS
	br -algorithm ${ALGORITHM} -path "${DATAPATH}/MEDS/img" -compare $target $query MEDS.mtx -eval ${ALGORITHM}_MEDS.mtx MEDS.mask ${ALGORITHM}_MEDS.csv

	# Plot results
	br -plot ${ALGORITHM}_MEDS.csv lfw.pdf

}


function findBestMatch {
	br -eval 

}

function createMask {
	br -makeMask $target $query $mask
}

function compareFaces {
	if [ ! -f $1 ] && [ ! -f $2 ];
	then
		echo "agrs is files"
		exit 1
	fi
	br -algorithm FaceRecognition -compare $1 $2 
}

#enrollFaces ../../openbr/data/MEDS/img ../../openbr/data/MEDS/img
#testPrope ../../openbr/data/MEDS/img/S001-01-t10_01.jpg
#compareFaces ../../openbr/data/MEDS/img/S001-01-t10_01.jpg ../../openbr/data/MEDS/img/S011-01-t10_01.jpg

#findBestMatch
#enrollFromWebcam
performLfwBench

#webcam