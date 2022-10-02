<?php
    require "requires/config.php";
    if ($_SERVER['REQUEST_METHOD'] == "POST") {
        if (trim($_POST['username']) == NULL) {
            Header("Location:login?error");
        }
        if (trim($_POST['password']) == NULL) {
            Header("Location:login?error");
        }
        $query = $con->query("SELECT * FROM users WHERE username = '".$con->real_escape_string($_POST['username'])."'");
        if ($query->num_rows == 1) {
            $row = $query->fetch_assoc();
            if (password_verify($_POST['password'],$row['password'])) {
                $_SESSION['loggedin'] = true;
                $_SESSION['username'] = $_POST['username'];
                $_SESSION['role'] = $row['role'];
                $_SESSION['name'] = $row['name'];
                $_SESSION['rank'] = $row['rank'];
                $_SESSION['id'] = $row['id'];
                $_SESSION["personid"] = NULL;
                $_SESSION["reportid"] = NULL;
                $con->query("UPDATE users SET last_login = '".date('Y-m-d')."' WHERE id = '".$row['id']."'");
                if ($_SERVER['HTTP_REFFER'] != "") {
                    header('Location: ' . $_SERVER['HTTP_REFERER']);
                } else {
                    Header("Location: dashboard");
                }
            } else {
                Header("Location: login?error");
            }
        } else {
            Header("Location: login?error");
        }
    }
?>
<!doctype html>
<html lang="en">
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
		<meta name="description" content="">
		<meta name="author" content="Polygon>
		<link rel="shortcut icon" href="img/fav.png" />

		<!-- Title -->
		<title>Meos</title>
		<link rel="stylesheet" href="../css/bootstrap.min.css" />

		<!-- Master CSS -->
		<link rel="stylesheet" href="../css/main.css" />

	</head>

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
                                <p style="color:#9f1010;"><?php echo $gen_wrongpw;?></p>
                                <?php } ?>
								<div class="form-group">
									<input type="text" name="username" class="form-control" placeholder="<?php echo $gen_username;?>" />
								</div>
								<div class="form-group">
									<input type="password"  name="password" class="form-control" placeholder="<?php echo $gen_pw;?>" />
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

	</body>
</html>