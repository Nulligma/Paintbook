<?php
	include_once("ServerDetails.php");

	//$name = $_POST['name'];
	//$backcolor = $_POST['backcolor'];
	//$color1 = $_POST['color1'];
	//$color2 = $_POST['color2'];

	$tableName = ServerDetails::THEMES_TABLE_NAME;

	$theme 				= new stdClass();
	$theme->name 		= $_POST['name'];
	$theme->backcolor 	= $_POST['backcolor'];
	$theme->color1 		= $_POST['color1'];
	$theme->color2 		= $_POST['color2'];
	$theme->tag1		= $_POST['tag1'];
	$theme->tag2		= $_POST['tag2'];
	$theme->tag3		= $_POST['tag3'];


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
	foreach($theme as $id=>$key)
	{
	  $insertPairs[($id)] = ($key);
	}
	  
	$insertKeys = '`' . implode('`,`', array_keys($insertPairs)) . '`';
	$insertVals = '"' . implode('","', array_values($insertPairs)) . '"';
	  
	$sql = "INSERT INTO `{$tableName}` ({$insertKeys}) VALUES ({$insertVals});" ;
	$stmt = $serverConnection->prepare($sql);
	$stmt->execute(); 
?>
