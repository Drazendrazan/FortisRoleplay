<?php
    require "../requires/config.php";
    if ($_SESSION['server_logged']) 
        Header("Location: controlpanel");
    else
         Header("Location: access");
    
?>