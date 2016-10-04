<?php
$output = array();
$request = file_get_contents("php://input");
$arr = json_decode($request,TRUE);
$data1 = $arr['data1']?$arr['data1']:'';
$data2 = $arr['data2']?$arr['data2']:'';
$data3 = $arr['data3']?$arr['data3']:'';
$data4 = $arr['data4']?$arr['data4']:'';
$data5 = $arr['data5']?$arr['data5']:'';
$index = $arr['index']?$arr['index']:1;

if ($index == 1) {
	$fp = fopen("data.dat","w+");
}
else {
	$fp = fopen("data_temp.dat","w+");
}
	fwrite($fp,$data1."\r\n");
	fwrite($fp,$data2."\r\n");
	fwrite($fp,$data3."\r\n");
	fwrite($fp,$data4."\r\n");
	fwrite($fp,$data5);
	fclose($fp);

if ($index != 1) {
	$command = "/Applications/MATLAB_R2014b.app/bin/matlab -nojvm -nodesktop -nodisplay -r get_data2\($index\)";
	exec($command, $info,$var);
}

//print $index.'<br>';

if ($index >= 4) {
	$time_start = ($index-4)*2;
	$command = "/Applications/MATLAB_R2014b.app/bin/matlab -nojvm -nodesktop -nodisplay -r MAIN\($time_start\)";
	exec($command, $info,$var);
	$fp = fopen("bpm.dat","r");
	$bpm = fgets($fp);
	fclose($fp);

	if ($index == 4){
		$fp = fopen("all_bpm.dat","w+");
		fwrite($fp,$bpm."\r\n");
		fclose($fp);
	}
	else {
		$fp = fopen("all_bpm.dat","a+");
		fwrite($fp,$bpm."\r\n");
		fclose($fp);
	}

	$output = array('bpm' => (double)$bpm, 'err_code' => $var, 'index' => $index);
}
else {
	$output = "Not enough input arguments!";
}
exit(json_encode($output));


?>
