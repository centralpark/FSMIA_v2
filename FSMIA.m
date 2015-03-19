% FSMIA starting the Fluorescent Single Molecule Image Analysis
% Siheng He
% Department of Biomedical Engineering, Columbia University
% Last modified date: June 17, 2013
clc
clear
clearvars -global
global PathBackup;
global DirRoot;
global Option;
global Molecule;
global Frame;
global Result;
Option.exclude = false;
Option.connectDistance = 160;  % nm
Option.ClusterThreshold = 100;
Option.connectGap = false;

%backup path to reset path after closing FSMIA
PathBackup = path;

%get path where FSMIA.m was started
DirRoot = [fileparts( mfilename('fullpath') ) filesep];

%Set root directory for FSMIA
DirBin = [DirRoot 'bin' filesep];

%add path to FSMIA functions
addpath(genpath(DirBin));
    
% finally start the application
MainGUI;