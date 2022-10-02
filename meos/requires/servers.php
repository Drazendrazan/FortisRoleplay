<?php require_once 'config.php'

class Servers 
{
    private $_serverID
    private $_serverName;
    private $_serverOwner;

    function __construct()
    {
        $query = $con->query("SELECT * FROM `servers` WHERE `server_owner`");
        $query->fetch_assoc();
    }
}


?>