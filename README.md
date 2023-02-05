# Design and Implementation of Handwriting Recognition System Based on Inertial Sensors

### Abstract
Handwriting on paper is a long-term way of information record. Handwriting
behavior is completed under the combined action of hand and arm muscles, eyes, brain
and other organs. It plays an important role in the memory and understanding of
information. Traditional paper handwriting recognition relies on OCR technology, which requires users to take photos after handwriting for image recognition. This paper
aims to realize the automatic recognition of the user's handwriting on paper through the
built-in sensor of the smart watch, so that the user's handwriting content can be stored
digitally without the user's explicit interaction. This paper studies the design and development of handwritten capital letter
recognition system based on the built-in inertial sensor of smart. Users wear the smart
watch and write capital letters on paper. This paper, analyzed the signal sequence of
wrist in the process of handwriting recorded by the inertial sensor of smart watch, and
carried out the handwriting recognition. The recognition scheme of this paper is mainly
divided into four modules: letter cutting, stroke cutting, stroke recognition and letter
recognition. Through the time-frequency analysis of the inertial sensor sequence, the letter
cutting module extracts the wrist lifting action in the writing process, and separates the
sample sequence of each letter from the whole writing sequence. Because the capital
letters can be divided into strokes in the process of writing. This paper splits 21 strokes
from 26 capital letters based on the standard stroke order of capital English letters. By
analyzing the data sequence of each letter in time and frequency domain again, the
stroke cutting module completes the strokes cut from the capital letters. The stroke
recognition module constructs a stroke recognition model through long and short-term
memory neural network to recognize the cut strokes. After the prediction of stroke
labels, the letter recognition module corrects part of the wrong predicted stroke
labels .According to the number of strokes of each letter, the prediction labels of
strokes and the confusion matrix of LSTM, determines the content of a sample of
handwritten capital letters. This paper uses 50 groups of alphabet data to train the model, and collected
writing data of in total 587 letters (including 1135 strokes) from three volunteers to
evaluates the whole system. The final prediction accuracy of stroke and letter label is
49.6% and 62.01%. Stroke prediction recognition rate may be limited by the accuracy
of stroke segmentation and stroke enumeration. Letter recognition accuracy is limited
by the stroke recognition accuracy. The future research will try to improve the
recognition accuracy of the system by optimizing stroke segmentation and enumeration, adding dictionary correction and other methods.

### Execute
This is a group of script but not a complete pipline. But you can still try to run it with the instore data.
Simply run the Main\main.m, there is three lines of addpath() on the top, change it to your own path.
