<?php
    require 'header.php';

    $page['register']['error']['no_input'] = "Ongeldige input";
    $page['register']['error']['pass_not_same'] = "Wachtwoorden komen niet overeen";
    $page['register']['error']['already_exist'] = "Er bestaat al een account";
    $page['register']['error']['pass_len'] ="Wachtwoord moet langer zijn dan 8 tekens";
    $page['register']['success']['account_created'] ="Je account is aangemaakt!";

    if(isset($_POST['reg']))
    {
        $username = trim($_POST['username']);
        $password = $_POST['password'];
        $newsletter = ($_POST['newsletter']) ? 1 : 0;

        $error = array();
        if(!isset($username) or !isset($password))
            $error[] = $page['register']['error']['no_input'];
        
        if($_POST['password2'] !== $password)
            $error[] = $page['register']['error']['pass_not_same'];

        if(strlen($password) < 8)
        $error[] = $page['register']['error']['pass_len'];

        $password = password_hash($password, PASSWORD_DEFAULT);      

        $sql = "SELECT `email` FROM `server_owner` WHERE `email` ='".$username."'";
        $query = $con->query($sql);        
        if(!$query)
        echo $con->error;
        $result = $query->num_rows;

        echo $result;
        if($result != 0)
         $error[] = $page['register']['error']['already_exist'];
         
        if(count($error) != 0 ){
            for($i =0; $i < count($error); $i++)
                errorMsg($error[$i]);

            return;
        }
       
        //infometa      
            // {
            //     "email": $con->real_escape_string($username),
            //     "password": $password,
            //     "ip": $_SERVER['REMOTE_ADDR']
            // }

        $sql = "INSERT INTO `server_owner` (`email`, `password`, `newsletter`) VALUES ('".$con->real_escape_string($username)."','".$password."','".$newsletter."')";
        $con->query($sql);

        successMsg($page['register']['success']['account_created']);
    

    }
?>
<div class="container col-md-2 offset-md-5">
    <form method='POST' action='/register'>
        <div class="form-group col-md-2">
            <label for='Meos server username'>Username</label>
            <input type='email' class='form-control' id='meosemail' name='username' required aria-describeby='MeosLoginEmail' placeholder='Enter email' />
        </div>
        <div class="form-group col-md-2">
            <label for='Meos server password'>Password</label>
            <input type='password' class='form-control' id='meosemail' name='password' required aria-describeby='MeosPassword' placeholder='Enter password' />
        </div>
        <div class="form-group col-md-2">
            <label for='Meos server password'>Password check</label>
            <input type='password' class='form-control' id='meosemail' name='password2' required aria-describeby='MeosPasswordCheck' placeholder='Enter password' />
        </div>
        <div class="form-check">
        <input type="checkbox" name="newsletter" checked class="form-check-input" id="newlettersignup">
        <label class="form-check-label" for="NewsLetterSignup">Newsletter signup</label>
        </div>
        <button type='submit' name='reg' class="btn btn-primary offset-md-2">Register account</button>
    </form>
</div>
<?php

    require 'footer.php';
?>