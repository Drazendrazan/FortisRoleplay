<?php
    require "../requires/config.php";
	

	$request_uri = $_SERVER['REQUEST_URI'];
	$request_uri = trim($request_uri, '/');
   
	 if($request_uri != 'server/access' && $request_uri != 'server/register')
          if(!$_SESSION['server_logged'])
            header('Location: access');
   
	


    
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
 
    <!-- <script src="./assets/js/car-replace-names.js" defer></script> -->
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
            <div class="main-container">
				<div class="page-title">
					<div class="row gutters">
						<div class="col-xl-6 col-lg-6 col-md-6 col-sm-12 col-12">
							<h5 class="title"><?php if ($_SESSION['loggedin']) { echo $dash_welcome . $_SESSION["rank"] . " " . $firstname; } else echo 'Welkom stranger'  ?></h5>
						</div>
					</div>
				</div>
				<div class="content-wrapper" style="min-height: 300px;">