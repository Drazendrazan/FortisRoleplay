<?php
    require "requires/config.php";


	$request_uri = $_SERVER['REQUEST_URI'];
	$request_uri = trim($request_uri, '/');

	if($request_uri != 'register'){
		if (!$_SESSION['loggedin']) {
			Header("Location: login");
		}
	}



?>
<!doctype html>
<html lang="en">
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

		<!-- Meta -->
		<meta name="description" content="">
		<meta name="author" content="Polygon roleplay">
		<link rel="shortcut icon" href="../img/fav.png" />

		<!-- Title -->
		<title>Meos</title>
		<link rel="stylesheet" href="../css/bootstrap.min.css">
		<link rel="stylesheet" type="text/css" href="../fonts/style.css">
		<link rel="stylesheet" href="../css/main.css">
		<link rel="stylesheet" href="../vendor/daterange/daterange.css" />

        <style>
        .material-icons {
            font-size: 1.8rem !important;
        }
        </style>

	<link href='https://cdn.jsdelivr.net/npm/froala-editor@latest/css/froala_editor.pkgd.min.css' rel='stylesheet' type='text/css' />
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>

	<script type='text/javascript' src='https://cdn.jsdelivr.net/npm/froala-editor@latest/js/froala_editor.pkgd.min.js'></script>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

    <script src="../assets/js/car-replace-names.js" defer></script>
	</head>
	<body>


		<div class="container">
			<header class="header">
				<div class="row gutters">
					<div class="col-xl-4 col-lg-4 col-md-6 col-sm-6 col-6">
                        <a href="./dashboard" class="logo">
							<?php echo $webname; ?>
						</a>
					</div>
					<div class="col-xl-8 col-lg-8 col-md-6 col-sm-6 col-6">
						<ul class="header-actions">
							<li class="dropdown">
								<a href="#" id="userSettings" class="user-settings" data-toggle="dropdown" aria-haspopup="true">
									<span class="user-name"><?php echo $firstname;?></span>
									<span class="avatar"><?php echo $firstname[0];?><span class="status online"></span></span>
								</a>
								<div class="dropdown-menu dropdown-menu-right" aria-labelledby="userSettings">
									<div class="header-profile-actions">
										<a href="logout.php"><i class="icon-log-out1"></i> <?php echo $gen_logout; ?></a>
									</div>
								</div>
							</li>
						</ul>
					</div>
				</div>
			</header>
			<nav class="navbar navbar-expand-lg custom-navbar">
				<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#retailAdminNavbar" aria-controls="retailAdminNavbar" aria-expanded="false" aria-label="Toggle navigation">
					<span class="navbar-toggler-icon">
						<i></i>
						<i></i>
						<i></i>
					</span>
				</button>
				<div class="collapse navbar-collapse" id="retailAdminNavbar">
					<ul class="navbar-nav m-auto">
                        <li class="nav-item">
							<a class="nav-link <?php if($pg == 'dashboard'){?>active-page<?php }?>" href="./dashboard">
                            <i class="nav-icon"><span class="material-icons">home</span></i>
							<?php echo $menu_dashboard; ?>
							</a>
						</li>
						<li class="nav-item">
							<a class="nav-link <?php if($pg == 'profiles' || $pg == 'createprofile'){?>active-page<?php }?>" href="./profiles">
                            <i class="nav-icon"><span class="material-icons">person</span></i>
							<?php echo $menu_citizens; ?>
							</a>
						</li>
						<li class="nav-item">
							<a class="nav-link <?php if($pg == 'reports' || $pg == 'createreport'){?>active-page<?php }?>" href="reports">
                            <i class="nav-icon"><span class="material-icons">summarize</span></i>
							<?php echo $menu_reports; ?>
							</a>
						</li>
						<?php if($features['bill']) { ?>
						<li class="nav-item">
							<a class="nav-link <?php if($pg == 'bills' || $pg == 'bills'){?>active-page<?php }?>" href="bills">
                            <i class="nav-icon"><span class="material-icons">summarize</span></i>
							<?php echo $menu_billing; ?>
							</a>
						</li>
						<?php } if($features['vehicles']) {?>
						<li class="nav-item">
							<a class="nav-link <?php if($pg == 'vehicles' || $pg == 'createvehicle'){?>active-page<?php }?>" href="vehicles">
                            <i class="nav-icon"><span class="material-icons">directions_car</span></i>
							<?php echo $menu_vehicles; ?>
							</a>
						</li>
						<?php
						} if($features['houses']){
						?>
						<li class="nav-item">
							<a class="nav-link <?php if($pg == 'houses'){?>active-page<?php }?>" href="houses">
                            <i class="nav-icon"><span class="material-icons">maps_home_work</span></i>
							<?php echo $menu_houses; ?>
							</a>
						</li>
						<?php
						} if($features['warrants']) {
						?>
						<li class="nav-item">
							<a class="nav-link <?php if($pg == 'warrants' || $pg == 'createwarrant'){?>active-page<?php }?>" href="warrants">
                            <i class="nav-icon"><span class="material-icons">travel_explore</span></i>
							<?php echo $menu_warrents; ?>
							</a>
						</li>
						<?php } ?>
						<?php if ($_SESSION["role"] == "admin") { ?>
						<li class="nav-item dropdown">
							<a class="nav-link dropdown-toggle <?php if($pg == 'laws' || $pg == 'users'){?>active-page<?php }?>" href="#" id="appsDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            <i class="nav-icon"><span class="material-icons">settings</span></i>
							<?php echo $menu_admin; ?>
							</a>
							<ul class="dropdown-menu dropdown-menu-right" aria-labelledby="appsDropdown">
								<li>
									<a class="dropdown-item" href="laws"><?php echo $menu_laws; ?></a>
								</li>
								<li>
									<a class="dropdown-item" href="users"><?php echo $menu_accounts; ?></a>
								</li>
								<li>
									<a class="dropdown-item" href="features"><?php echo $menu_features; ?></a>
								</li>
							</ul>
						</li>
						<?php } ?>
					</ul>
				</div>
			</nav>
			<div class="main-container">
				<div class="page-title">
					<div class="row gutters">
						<div class="col-xl-6 col-lg-6 col-md-6 col-sm-12 col-12">
							<h5 class="title"><?php if ($_SESSION['loggedin']) { echo $dash_welcome . $_SESSION["rank"] . " " . $firstname; } else echo 'Welkom stranger'  ?></h5>
						</div>
					</div>
				</div>
				<div class="content-wrapper" style="min-height: 300px;">

<?php

	if(isset($features[$request_uri]) && !$features[$request_uri])
	{
		errorMsg( $error_no_access);
		exit();
	}
?>