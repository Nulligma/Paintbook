<?php
// Set local PHP vars from the POST vars sent from flash
	include_once("ServerDetails.php");

	$name = $_POST['name'];
	$backcolor = $_POST['backcolor'];
	$color1 = $_POST['color1'];
	$color2 = $_POST['color2'];

	$db_name = ServerDetails::DB_NAME;
	$ffmpegLoc = ServerDetails::FFMPEG_LOCATION;

	$cnfn = ServerDetails::COUNTRY_FIELD_NAME;
	$fnfn = ServerDetails::FILE_NUMBER_FIELD_NAME;
	$txfn = ServerDetails::TEXT_FIELD_NAME;
	$tsfn = ServerDetails::TIMESTAMP_FIELD_NAME;

	if(!$serverConnection=mysqli_connect(ServerDetails::SERVER_PATH,ServerDetails::SERVER_USER_ID,ServerDetails::SERVER_PASSWORD))
	{
		echo "Unable to connect to server" . mysqli_connect_error();
        exit;
    }

    if (!mysqli_select_db($serverConnection,$db_name))
    {
        echo "Unable to select EcoOfSapiensDB: " . mysqli_error();
        exit;
    }

	if($fileType == ServerDetails::LOCAL_SOUND_NAME)
	{
		$table_name = ServerDetails::SOUND_TABLE_NAME;
		$fileExtention = ServerDetails::SOUND_FILE_EXTENTION;
		$fixedUploadPath = ServerDetails::SERVER_SOUND_FIXED_FILEPATH;
	}
	else if($fileType == ServerDetails::LOCAL_PIC_NAME)
	{
		$table_name = ServerDetails::PICS_TABLE_NAME;
		$fileExtention = ServerDetails::PICS_FILE_EXTENTION;
		$fixedUploadPath = ServerDetails::SERVER_PICS_FIXED_FILEPATH;
	}
	else
	{
    	echo "Inside Text";
		$table_name = ServerDetails::TEXT_TABLE_NAME;

		$newFileNumberTxt = CreateFileNumber($serverConnection,$db_name,$table_name ,$fnfn,$tsfn);

		$Txtsql="insert into $table_name ($fnfn,$cnfn,$txfn) Values ($newFileNumberTxt,'$country','$text')";
    	$Txtinsert=mysqli_query($serverConnection, $Txtsql) or die ("Error: ".mysqli_error($serverConnection));

    	echo "Good";
    	return;
	}


	$date = getdate(); $year = $date['year']; $month = $date['month']; $day = $date['mday'];
	$fileMakePath = "$fixedUploadPath/$year/$month/$day/";

	if (!file_exists("$fixedUploadPath/$year/$month/$day")) mkdir("$fixedUploadPath/$year/$month/$day",0777,true);


    //$numberQuery = "SELECT Name FROM $table_name ORDER BY UploadDate DESC LIMIT 1;";
    //$getLatestNumber=mysqli_query($serverConnection, $numberQuery) or die ("Error: ".mysql_error($serverConnection));

    $newFileNumber = CreateFileNumber($serverConnection,$db_name,$table_name ,$fnfn,$tsfn);

    $newFileName = $newFileNumber.$fileExtention;

	$sql="insert into $table_name ($fnfn,$cnfn) Values ($newFileNumber,'$country')";
    $insert=mysqli_query($serverConnection, $sql) or die ("Error: ".mysqli_error($serverConnection));


	if($fileType == ServerDetails::LOCAL_SOUND_NAME)
	{
		$mp3_options = '-acodec libmp3lame -ab 64k';
		$output = $fileMakePath.$newFileName;
		if(exec($ffmpegLoc." -i $filetmpname $mp3_options $output 2>&1" ))
			{
				echo "Good";
			}
			else
			{
				echo "not good";
			}
	}
	else
	{
		echo("in here");
		$imgInfo = getimagesize($filetmpname);
		echo($imgInfo[0]);

		$width = $imgInfo[0];
		$height = $imgInfo[1];

		$image = imagecreatefromjpeg($filetmpname);
		if($width>$height)
		{
			$image = imagerotate($image, 90, 0);
			$width = $imgInfo[1];
			$height = $imgInfo[0];
		}

		$scale = 1200/$height;

		$newHeight = $height * $scale;
		$newWidth = $width * $scale;

		$scaledImage = imagescale($image,$newWidth,$newHeight,IMG_BILINEAR_FIXED);
		$output = $fileMakePath.$newFileName;

		header('Content-Type: image/jpeg');
		imagejpeg($scaledImage,$output,35);
		/*if(exec($ffmpegLoc." -i $filetmpname $image_options $output 2>&1" ))
			{
				echo "Good";
			}
			else
			{
				echo "not good";
			}*/
	}

	/*if(move_uploaded_file($filetmpname, $fileMakePath.$newFileName))
	{
		echo "successfully uploaded file";
	}
	else
	{
		echo "error uploading file". mysqli_error();
	}*/

	mysqli_close($serverConnection);
?>