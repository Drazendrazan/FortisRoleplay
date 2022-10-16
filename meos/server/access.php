<?php
    require_once 'header.php';


	$page['server_login']['success']['loggedin'] = "Je bent nu ingelogt";
	$page['server_login']['error']['wrong_info'] = "Ingevoerde informatie klopt niet of bestaat niet!";
	$page['server_login']['error']['empty_fields'] = "Een of meerderen velden zijn leeg!";
	$page['server_login']['error']['not_exist'] ="Gebruiker bestaat niet";


    if ($_SERVER['REQUEST_METHOD'] == "POST") {

		$error = array();

        if (trim($_POST['username']) == NULL || trim($_POST['password']) == NULL) 
            $error[] =$page['server_login']['error']['empty_fields'];
        
       	$sql = "SELECT * FROM `server_owner` WHERE `email` = '".$con->real_escape_string($_POST['username'])."' LIMIT BY 1";
		$query = $con->query($sql);

	
		if($query->num_rows == 0)
		 	$error[] = $page['server_login']['error']['not_exist'];

		$query = $con->query("SELECT * FROM `server_owner` WHERE `email` = '".$con->real_escape_string($_POST['username'])."'");
		$row = $query->fetch_assoc();

		if(!password_verify($_POST['password'], $row['password']))
			$error[] = $page['server_login']['error']['wrong_info'];
		

		if(count($error) != 0)
		{
			for($i = 0; $i < count($error); $i++)
				Header("Location: access?error=".$error[$i]);
				//errorMsg($error[$i]);
			
			return;
		}

		$_SESSION['server_logged'] = true;
		$_SESSION['email'] = $row['email'];
		$con->query("UPDATE `server_owner` SET lastlogged = '".date('Y-m-d')."' WHERE `uid` = '".$row['uid']."'");

		Header("Location: dashboard");

        // $query = $con->query("SELECT * FROM users WHERE username = '".$con->real_escape_string($_POST['username'])."'");
        // if ($query->num_rows == 1) {
        //     $row = $query->fetch_assoc();
        //     if (password_verify($_POST['password'],$row['password'])) {
        //         $_SESSION['loggedin'] = true;
        //         $_SESSION['username'] = $_POST['username'];
        //         $_SESSION['role'] = $row['role'];
        //         $_SESSION['name'] = $row['name'];
        //         $_SESSION['rank'] = $row['rank'];
        //         $_SESSION['id'] = $row['id'];
        //         $_SESSION["personid"] = NULL;
        //         $_SESSION["reportid"] = NULL;
        //         $con->query("UPDATE users SET last_login = '".date('Y-m-d')."' WHERE id = '".$row['id']."'");
        //         if ($_SERVER['HTTP_REFFER'] != "") {
        //             header('Location: ' . $_SERVER['HTTP_REFERER']);
        //         } else {
        //             Header("Location: dashboard");
        //         }
        //     } else {
        //         Header("Location: login?error");
        //     }
        // } else {
        //     Header("Location: login?error");
        // }
    }
?>


	<body class="authentication">

		<!-- Container start -->
		<div class="container">
			
        <form method="post">
				<div class="row justify-content-md-center">
					<div class="col-xl-4 col-lg-5 col-md-6 col-sm-12">
						<div class="login-screen">
							<div class="login-box">
								<a href="index.php" class="login-logo">
								<?php echo $webname; ?>
								</a>
                                
                                <?php if (isset($_GET['error'])) { ?>
                                <p style="color:#9f1010;"><?php echo $_GET['error'];?></p>
                                <?php } ?>
								<div class="form-group">
									<input type="text" name="username" required class="form-control" placeholder="<?php echo $gen_username;?>" />
								</div>
								<div class="form-group">
									<input type="password"  name="password" required class="form-control" placeholder="<?php echo $gen_pw;?>" />
								</div>
								<div class="actions">
									<button type="submit" class="btn btn-info"><?php echo $gen_login;?></button>
									<a href='server/register' class="btn btn-info"><?php echo "Aanmelden";?></a>
									
								</div>
								
								<div class="m-0">
								</div>
							</div>
						</div>
					</div>
				</div>
			</form>

		</div>
		<!-- Container end -->
<?php
	require_once 'footer.php';
?>
	</body>
</html>