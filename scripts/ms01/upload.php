<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $targetDirectory = __DIR__ . "/uploads/";
    $targetFile = $targetDirectory . basename($_FILES["file"]["name"]);
    $uploadOk = 1;
    $fileType = strtolower(pathinfo($targetFile, PATHINFO_EXTENSION));

    // Check if the file is a .doc file
    if ($fileType != "doc") {
        echo "Only .doc files are allowed.";
        $uploadOk = 0;
    }

    // Check if the file already exists
    if (file_exists($targetFile)) {
        echo "File already exists.";
        $uploadOk = 0;
    }

    // Check if $uploadOk is set to 0 by an error
    if ($uploadOk == 0) {
        echo "Sorry, your file was not uploaded.";
    } else {
        // Create the 'uploads' directory if it doesn't exist
        if (!file_exists($targetDirectory)) {
            mkdir($targetDirectory);
        }

        // Move the file to the target directory
        if (move_uploaded_file($_FILES["file"]["tmp_name"], $targetFile)) {
            echo "The file " . basename($_FILES["file"]["name"]) . " has been uploaded.";
        } else {
            echo "Sorry, there was an error uploading your file.";
        }
    }
}
?>
