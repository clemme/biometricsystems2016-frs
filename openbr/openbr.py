from brpy import init_brpy


pictureDest = '/home/casper/repos/openbr/data/MEDS/img/'
br = None

def main():
    br = init_brpy()
    br.br_initialize_default()
    br.br_set_property('algorithm', 'FaceRecognition')
    br.br_set_property('enrollAll', 'true')
    enrollFaces(pictureDest)

def enrollFaces(pictures):
    print "Beginnig to enrole %s" % pictures
    aPic = open(pictures + 'S048-01-t10_01.jpg', 'rb').read()
    mycatstmpl = br.br_load_img(aPic, len(aPic))
    query = br.br_enroll_template(mycatstmpl)
    print query
    nqueries = br.br_num_templates(query)
    print nqueries


if __name__ == "__main__":
    print "Beginnig performance benchmarking of openbr"
    main()
    br.br_finalize()
