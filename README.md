# Carnicer-Lombarte-et-al-2023

## Electrophysiology data analysis
Matlab code to filter and analyse electrophysiology recordings from ultraconformable cuffs

**read_Intan_RHS2000_file.m** - Imports recording data from intan data file format (.rhs) to matlab. Provided by Intan Technlogies (https://intantech.com/downloads.html?tabSelect=Software&yPos=100)

**Processed_bipolar_MEA_Intan.m** - Bandpass filters and performs referencing of imported recordings

**MetricsEphys.m** - Obtains metrics (SNR, peak amplitude, etc) from defined periods of noise and activity in a recording

**Thresholding_markers.m** - Identifies proportion of spikes which co-occur in one or more of the input channel recordings (sub-nerve recording around circumference) 

**ISI_custom.m** - Produces modified inter-spike interval histogram of delay between every spike in one channel to spikes in a second channel (spike velocity sorting)

**Correlation_coefficient.m** - Carries out a cross-correlation calculation between two channel recordings at various delays (spike velocity sorting)

## Immunostaining image analysis
Code to analyse stains of fibrosis around nerves implanted with cuffs 

**FBR_preprocessing.ijm** - Fiji (ImageJ) macro to straighten and pre-procecess fibrotic capsules around nerve tissue at the boundary with cuffs

**FBR_capsule.m** - Matlab code to obtain a profile of stain intensity as a factor of depth into tissue, starting from the edge at the interface with implant.

## Kinematic analysis
Matlab code to extract kinematics from recordings of paw movement due to nerve stimulation

**FrameLookup.m** - interactively provides location coordinates on a video frame number of interest






