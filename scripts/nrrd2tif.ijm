// ImageJ macro lsm2nrrdPP.ijm
// Designed to open and PreProcess 1 channel tif image stacks and output 1 NRRD file
// Written by Robert Court - r.court@ed.ac.uk 


name = getArgument;
if (name=="") exit ("No argument!");
setBatchMode(true);

outfile = replace(name, ".nrrd", ".tif");
wait(200);
run("Nrrd ...", "load=[" + name + "]");
wait(400);
saveAs("Tiff", outfile);
wait(200);

run("Quit");

