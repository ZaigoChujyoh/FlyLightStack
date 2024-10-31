//Ver1.0-----------------------------------------------------------------------------
//作業ディレクトリの選択
showMessage("Select Open Folder");
dir = getDirectory("Choose Directory");
list = getFileList(dir); //作業ディレクトリの中にあるファイルのリスト
list_read = Array.filter(list, ".tif"); //.tifのみのリスト

//データ保存用のディレクトリを作成
savedir = dir + "stack\\"
if(!File.exists(savedir)){
	File.makeDirectory(savedir)
};

for(j=0; j<list_read.length; ++j){
	name = list_read[j];
	extension = indexOf(name, "."); //拡張子(.を含む)
	namewithoutextension = substring(name, 0, extension); //元データは"namewithoutextension + extension"
	path = dir+name;
	saveextension = "png";
	
	open(path);	
	run("Split Channels");
	run("Merge Channels...", "c2=["+name+" (green)] c3=["+name+" (blue)] create");
	run("Z Project...", "projection=[Max Intensity]"); //Stack
	for(k=0; k<2; k++){
		Stack.setChannel(k+1);
		run("Enhance Contrast", "saturated=0.35");
	}
	saveAs(saveextension, savedir + namewithoutextension + "_stack_" + "." + saveextension);
	close("*");
}

Dialog.create("Finished");
Dialog.addMessage("All files have been successfully stacked!");
Dialog.show;