 br -algorithm FaceRecognition -path ../../../openbr/data/MEDS/img/ \
-enroll ../../../openbr/data/MEDS/sigset/MEDS_frontal_target.xml target.gal \
-enroll ../../../openbr/data/MEDS/sigset/MEDS_frontal_query.xml query.gal \
-compare target.gal query.gal scores.mtx \
-makeMask ../../../openbr/data/MEDS/sigset/MEDS_frontal_target.xml ../../../openbr/data/MEDS/sigset/MEDS_frontal_query.xml MEDS.mask \
-eval scores.mtx MEDS.mask Algorithm_Dataset/FaceRecognition_MEDS.csv \
-plot Algorithm_Dataset/FaceRecognition_MEDS.csv MEDS
