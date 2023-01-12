function [PCA_2_2, PCA_2_3, PCA_3, scores, var_explained] = PCA_kinematics (Values, PCA_labels, PCA_colours);

%Generates PCA plots (2 and 3d, for 2 and 3 top PCAs) with text added as
%labels. Inputs are values to perform PCA on (variables in rows, repeats in
%columns - script will transpose it), and labels in a cell vector (again,
%input is as a row of labels, script will transpose). Last input is
%PCA_colours, which is a series of 3 RGB values to colour each marker.
%
%Outputs the 2D (with PC1 and PC2, and with PC1 and PC3) 
%and 3D plots, the PCA plots, and the variability explained.
%They will be saved as pdfs in folder as well. 3D one will also be saved as
%.fig to allow reopening it and rotating it around

Values = Values';

PCA_labels=PCA_labels';

[coeff,score,latent,tsquared,explained]=pca(Values);

var_explained=explained;

scores = score;

PCA_labels=PCA_labels';

%3D plot
%Text position can be altered by changing dx/dy/dz below.

dz=4; 
dy=dz; 
dx=dy;

PCA_3 = scatter3(score(:,1),score(:,2),score(:,3),[],PCA_colours,'filled');

xlabel('PC1');
ylabel('PC2');
zlabel('PC3');

text(score(:,1)+dx, score(:,2)+dy, score(:,3)+dz, PCA_labels);

saveas(gcf,'PCA_3D.fig')
saveas(gcf,'PCA_3D.pdf')

%2D plots

figure

PCA_2_2 = scatter(score(:,1),score(:,2),[],PCA_colours,'filled');

xlabel('PC1');
ylabel('PC2');

text(score(:,1)+dx, score(:,2)+dy, PCA_labels);

saveas(gcf,'PCA_2D_PC2.pdf')

figure

PCA_2_3 = scatter(score(:,1),score(:,3),[],PCA_colours,'filled');

xlabel('PC1');
ylabel('PC3');

text(score(:,1)+dx, score(:,3)+dy, PCA_labels);

saveas(gcf,'PCA_2D_PC3.pdf')