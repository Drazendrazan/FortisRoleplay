<?php
    error_reporting(1);
    ini_set("session.hash_function","sha512");
    session_start();
    ini_set("max_execution_time",500);
    ini_set('session.cookie_secure', 1);
    ini_set('session.cookie_httponly', 1);
    ini_set('session.use_only_cookies', 1);
    ini_set('session.cookie_samesite', 'None');

    // Login: admin // pepemeos
    $db_host = "85.215.216.205";
    $db_user = "rexis";
    $db_pass = "KaasKroket91!";
    $db_data = "meos";

    // $db_host = "localhost";
    // $db_user = "db.mmorpgguru.com";
    // $db_pass = "";
    // $db_data = "";

    $con = new mysqli($db_host,$db_user,$db_pass,$db_data);


    $db_host2 = "85.215.216.205";
    $db_user2 = "rexis";
    $db_pass2 = "KaasKroket91!";
    $db_data2 = "fortis";


    $con2 = new mysqli($db_host2,$db_user2,$db_pass2,$db_data2);

    // DATABASE
    // TABLES
    $license_key_meos = "";

    $player_db = "players";
    $houses_db = "player_houses";
    $vehicles_db = "player_vehicles";
    $bills_db = "phone_invoices";

    $webname = '<span class="text-danger">P</span>O<span class="text-danger">L</span>Y<span class="text-danger">G</span>O<span class="text-danger">N</span>';



    $features = array(
        "vehicles" => false,
        "houses" => true,
        "warrants" => true,
        "bills"=> true
    );

    // Language selection: nl.php for Dutch en.php for English.
    require("nl.php");


    function errorMsg($msg)
    {
        echo "<div class='alert alert-danger'>".$msg." </div>";
    }
    function successMsg($msg)
    {
        echo "<div class='alert alert-success'>".$msg." </div>";
    }
?>
