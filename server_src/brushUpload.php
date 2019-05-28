<?php
	include_once("ServerDetails.php");

	//$name = $_POST['name'];
	//$backcolor = $_POST['backcolor'];
	//$color1 = $_POST['color1'];
	//$color2 = $_POST['color2'];

	$tableName = ServerDetails::BRUSHES_TABLE_NAME;

	$brush 						= new stdClass();
	$brush->name 				= $_POST['name'];
	$brush->type 				= $_POST['type'];
	$brush->brushIndex 			= $_POST['brushIndex'];
	$brush->size 				= $_POST['size'];
	$brush->flow 				= $_POST['flow'];
	$brush->smoothness 			= $_POST['smoothness'];
	$brush->pressureSensivity 	= $_POST['pressureSensivity'];
	$brush->spacing 			= $_POST['spacing'];
	$brush->alpha 				= $_POST['alpha'];
	$brush->xSymmetry 			= $_POST['xSymmetry'];
	$brush->ySymmetry 			= $_POST['ySymmetry'];
	$brush->randomRotate 		= $_POST['randomRotate'];
	$brush->scattering 			= $_POST['scattering'];
	$brush->randomColor 		= $_POST['randomColor'];
	$brush->tag1				= $_POST['tag1'];
	$brush->tag2				= $_POST['tag2'];
	$brush->tag3				= $_POST['tag3'];

	$db_name = ServerDetails::DB_NAME;

	if(!$serverConnection=mysqli_connect(ServerDetails::SERVER_PATH,ServerDetails::SERVER_USER_ID,ServerDetails::SERVER_PASSWORD))
	{
		echo "Unable to connect to server".mysqli_connect_error();
        exit;
    }

    if (!mysqli_select_db($serverConnection,$db_name))
    {
        echo "Unable to select $db_name: ".mysqli_error($serverConnection);
        exit;
    }

	$insertPairs = array();
	foreach($brush as $id=>$key)
	{
	  $insertPairs[($id)] = ($key);
	}
	  
	$insertKeys = '`' . implode('`,`', array_keys($insertPairs)) . '`';
	$insertVals = '"' . implode('","', array_values($insertPairs)) . '"';
	  
	$sql = "INSERT INTO `{$tableName}` ({$insertKeys}) VALUES ({$insertVals});" ;
	$stmt = $serverConnection->prepare($sql);
	$stmt->execute(); 
?>
