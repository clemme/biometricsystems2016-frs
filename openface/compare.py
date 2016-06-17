import openface
import os
import argparse
import itertools
import cv2
import numpy as np
from PIL import Image

fileDir = os.path.dirname(os.path.realpath(__file__))
modelDir = os.path.join(fileDir, '../../../openface', 'models')
dlibModelDir = os.path.join(modelDir, 'dlib')
openfaceModelDir = os.path.join(modelDir, 'openface')
defaultImgs = '~/repos/openbr/data/lfw/Bill_Gates/{Bill_Gates_0001.jpg,Bill_Gates_0001.jpg}'
defaultdlibFacePredictor = os.path.join(dlibModelDir, "shape_predictor_68_face_landmarks.dat")
defaultnetworkModel = os.path.join(openfaceModelDir, 'nn4.small2.v1.t7')
defaultImgDim = 96

def getRepresentation(imgPath, saveAligned):
    img = cv2.imread(imgPath)

    align = openface.AlignDlib(defaultdlibFacePredictor)
    net = openface.TorchNeuralNet(defaultnetworkModel, defaultImgDim)
    rgbImg = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)

    # `img` is a numpy matrix containing the RGB pixels of the image.
    bb = align.getLargestFaceBoundingBox(rgbImg)
    alignedFace = align.align(defaultImgDim, rgbImg, bb,
                              landmarkIndices=openface.AlignDlib.OUTER_EYES_AND_NOSE)

    if saveAligned:
        alignedFaceImg = Image.fromarray(alignedFace)
        alignedFaceImg.save("alignedFace.jpg")

    rep = net.forward(alignedFace)
    return rep

def compare(img1, img2):
    d = getRepresentation(img1, True) - getRepresentation(img2, True)
    distance = np.dot(d, d)
    print("Comparing {} with {}.".format(img1, img2))
    print(
        "  + Squared l2 distance between representations: {:0.3f}".format(distance))
    return distance

if __name__ == '__main__':
    parser = argparse.ArgumentParser()

    parser.add_argument('imgs', type=str, nargs='+', help="Input images.",
                        default=defaultImgs)
    parser.add_argument('--dlibFacePredictor', type=str, help="Path to dlib's face predictor.",
                        default=defaultdlibFacePredictor)
    parser.add_argument('--networkModel', type=str, help="Path to Torch network model.",
                        default=defaultnetworkModel)
    parser.add_argument('--imgDim', type=int,
                        help="Default image dimension.", default=defaultImgDim)
    parser.add_argument('--verbose', action='store_true')

    # `args` are parsed command-line arguments.
    args = parser.parse_args()

    for (img1, img2) in itertools.combinations(args.imgs, 2):
        compare(img1, img2)
