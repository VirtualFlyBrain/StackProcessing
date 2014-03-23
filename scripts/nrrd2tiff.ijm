// Convert  nrrd files to tiff
/* Seymour+Ganesh+Nestor */

setBatchMode(true);
dirname = getArgument;
tiffdirname = dirname+"/tiff/";
print("Processing folder " + dirname);
nrrdfilepath=dirname;
print(nrrdfilepath);
filenames=getFileList(nrrdfilepath);
extension=".nrrd";
name="";
for(i=0;i<filenames.length;++i) {
 print(filenames[i]);
 if(!endsWith(filenames[i],extension)) {
 } else {
        nrrdfile = File.getName(filenames[i]);
	print("Processing nrrd: "+ nrrdfile);
        filename=substring(nrrdfile,0,lengthOf(nrrdfile)-5);
	print("Processing: " + nrrdfilepath+"/"+nrrdfile);
	nrrdfile = nrrdfilepath+"/"+nrrdfile;
	print ("NrrdFile: " + nrrdfile);
        open(nrrdfile);
	print ("Open dfile " +  nrrdfile);
//        command = "format=Tiff name="+filename+" digits=3 save="+tiffdirname;
	command = "save=" + tiffdirname + filename + ".tif";
	print("Command : " + command);
        run("Save", command);
        print ("Done!");
 }
}

