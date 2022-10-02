<?php
include("header.php");
    $respone = false;
    if ($_SERVER['REQUEST_METHOD'] == "GET") {
        if ($_GET['type'] == "search") {
            $result = $con->query("SELECT * FROM profiles WHERE concat(' ', fullname, ' ') LIKE '%".$con->real_escape_string($_GET['search'])."%' OR citizenid = '".$con->real_escape_string($_GET['search'])."' OR dnacode = '".$con->real_escape_string($_GET['search'])."' OR fingerprint = '".$con->real_escape_string($_GET['search'])."'");
            $search_array = [];
            while ($data = $result->fetch_assoc()) {
                $search_array[] = $data;
            }
        }elseif ($_GET['type'] == "show" || isset($_SESSION["personid"]) && $_SESSION["personid"] != NULL) {
            if (isset($_SESSION["personid"]) && $_SESSION["personid"] != NULL) {
                $personId = $_SESSION["personid"];
            } else {
                $personId = $_GET['personid'];
            }
            $query = $con->query("SELECT * FROM profiles WHERE id = ".$con->real_escape_string($personId));
            $selectedprofile = $query->fetch_assoc();
            $result = $con->query("SELECT * FROM reports WHERE profileid = ".$con->real_escape_string($personId)." ORDER BY created DESC");
            $update = $con->query("UPDATE profiles SET lastsearch = ".time()." WHERE id = ".$personId);
            $reports_array = [];
            while ($data = $result->fetch_assoc()) {
                $reports_array[] = $data;
            }
            $citizenid = $selectedprofile["citizenid"];
            $vehicle_result = $con2->query("SELECT * FROM $vehicles_db WHERE citizenid = '$citizenid'");
            while ($data = $vehicle_result->fetch_assoc()) {
                $vehicle_array[] = $data;
            }
            $_SESSION["personid"] = NULL;
        }
    }
?>


                <?php if ($_SERVER['REQUEST_METHOD'] == "GET" && $_GET['type'] == "show" && !empty($selectedprofile)) { ?>

                    

					<!-- Row start -->
					<div class="row gutters">
						<div class="col-xl-12 col-lg-12 col-md-12 col-sm-12 col-12">
							
							<!-- BEGIN .Custom-header -->
							<header class="custom-banner">
								<div class="row gutters">
									<div class="col-xl-4 col-lg-4 col-md-12 col-sm-12 col-12">
										<div class="welcome-msg">
											<div class="welcome-user-thumb">
                                                <img src="<?php echo $selectedprofile["avatar"]; ?>" alt="profile-pic" width="150" height="150" />
											</div>
											<div class="welcome-title">
                                                <?php echo $selectedprofile["fullname"]; ?>
											</div>
											<div class="welcome-title">
                                                <?php echo $gen_bsn; ?>: <?php echo $selectedprofile["citizenid"]; ?>
											</div>
										</div>
									</div>
                                    <div class="col-xl-8 col-lg-8 col-md-12 col-sm-12 col-12">
										<div class="row gutters user-plans justify-content-center">
                                            <p style="color:#fff; font-size:19px;">
                                            <?php echo $gen_finger; ?>: <?php echo $selectedprofile["fingerprint"]; ?><br />
                                            <?php echo $gen_dna; ?>: <?php echo $selectedprofile["dnacode"]; ?><br />
                                            <?php echo $selectedprofile["note"]; ?></p>
										</div>
									</div>
								</div>
							</header>
							<!-- END: .Custom-header -->

						</div>
					</div>
					<!-- Row end -->

                    <div class="profile-reports-panel">
                        <div class="profile-lastincidents">
                            <div class="row">
                                <div class="col-md-6 col-sm-12 mb-2">
                                    <form method="POST" action="createreport">
                                        <input type="hidden" name="type" value="createnew">
                                        <input type="hidden" name="profileid" value="<?php echo $selectedprofile['id']; ?>">
                                        <button type="submit" style="margin-left:0!important;" class="btn btn-success btn-md my-0 ml-sm-2 w-100"><?php echo $gen_newport; ?></button>
                                    </form>
                                </div>
                                
                                <div class="col-md-6 col-sm-12 mb-2">
                                    <form method="POST" action="createwarrant">
                                        <input type="hidden" name="type" value="create">
                                        <input type="hidden" name="profileid" value="<?php echo $selectedprofile['id']; ?>">
                                        <button type="submit" style="margin-left:0!important;" class="btn btn-danger btn-md my-0 ml-sm-2 w-100"><?php echo $gen_newwarrant; ?></button>
                                    </form>
                                </div>
                            
                            </div>

                            
					<div class="row gutters">
						<div class="col-md-6 col-sm-12">
							<div class="notify info">
								<div class="notify-body">
									<span class="type"><?php echo $gen_latestreports; ?> <?php if (!empty($reports_array)) { echo '('.count($reports_array).')'; }?></span>
                                    <?php if (empty($reports_array)) { ?>
                                    <p><?php echo $gen_noreports; ?></p>
                                <?php } else { ?>
                                    <?php foreach($reports_array as $report) {?>
                                        <form method="GET" action="reports">
                                            <input type="hidden" name="type" value="show">
                                            <input type="hidden" name="reportid" value="<?php echo $report['id']; ?>">
                                            <button type="submit" class="btn btn-panel panel-item">
                                                <h5 class="panel-title">#<?php echo $report['id']; ?> <?php echo $report['title']; ?></h5>
                                                <p class="panel-author"><?php echo $gen_by; ?>: <?php echo $report['author']; ?></p>
                                            </button>
                                        </form>
                                    <?php }?>
                                <?php } ?>
                                    </div>
							</div>
						</div>
                        
						<div class="col-md-6 col-sm-12">
							<div class="notify danger">
								<div class="notify-body">
									<span class="type"><?php echo $profiles_vehicleshead; if (!empty($vehicle_array)) { echo '('.count($vehicle_array).')'; }?></span>
                                    <?php if (empty($vehicle_array)) { ?>
                                    <p><?php echo $gen_novehicles; ?></p>
                                <?php } else { ?>
                                    <?php foreach($vehicle_array as $vehicle) {?>
                                        <form method="GET" action="vehicles">
                                            <input type="hidden" name="type" value="show">
                                            <input type="hidden" name="vehicleid" value="<?php echo $vehicle['id']; ?>">
                                            <button type="submit" class="btn btn-panel panel-item">
                                                <h5 class="panel-title"><?php echo replaceCars($vehicle['vehicle']); ?></h5>
                                                <p class="panel-author"><?php echo $gen_plate; ?>: <?php echo $vehicle['plate']; ?></p>
                                            </button>
                                        </form>
                                    <?php }?>
                                <?php } ?>
                				</div>
							</div>
						</div>
                    </div>
                    <div class="col-md-12 col-sm-12 mb-2">
                                    <form method="post" action="createprofile" class="d-inline">
                                        <input type="hidden" name="type" value="edit">
                                        <input type="hidden" name="profileid" value="<?php echo $selectedprofile['id']; ?>">
                                        <button type="submit" style="margin-left:0!important;" class="btn btn-info btn-md my-0 ml-sm-2 w-100"><?php echo $gen_editprofile; ?></button>
                                    </form>
                    </div>
                <?php } else { ?>
                    
					<div class="row gutters">
						<div class="col-12">
							<div class="notify info">
								<div class="notify-body">
									<span class="type"><?php echo $profiles_head; ?></span>
                                        <main role="main" class="container"><?php echo $profiles_info; ?>
                                            
                                            <div class="profile-container">
                                                <div class="profile-search mb-2">
                                                <br>
                                                    <form method="GET" class="form-inline ml-auto">
                                                        <input type="hidden" name="type" value="search">
                                                        <div class="input-group w-100">
                                                            <input class="form-control" name="search" type="text" placeholder="Zoek een persoon.." aria-label="Search">     
                                                            <div>
                                                                <button type="submit" class="btn btn-primary btn-police ml-2"><?php echo $gen_search; ?></button>
                                                            </div>
                                                        </div>
                                                    </form>
                                                    <?php if ($_SERVER['REQUEST_METHOD'] != "GET" || $_SERVER['REQUEST_METHOD'] == "GET" && $_GET['type'] != "show") { ?>
                                                        <a href="createprofile" class="btn btn-primary mt-2 w-100" ><?php echo $gen_newprofile; ?></a>
                                                    <?php } ?>
                                                </div>
                                            </div>
                                        </div>
                                     </div>
                <?php if ($_SERVER['REQUEST_METHOD'] == "GET" && $_GET['type'] == "search") { ?>
                    <div class="notify danger">
                    <div class="notify-body">
                    <span class="type"><?php echo $gen_foundperson; ?></span>
                        <div class="panel-list">
                            <?php if (empty($search_array)) { ?>
                                <p><?php echo $gen_nopersonsfound; ?></p>
                            <?php } else { ?>
                                <div class="row">
                                <?php foreach($search_array as $person) {?>
                                    <div class="col-sm-12 col-md-6 col-lg-4 col-xl-3">
                                    <form method="GET">
                                        <input type="hidden" name="type" value="show">
                                        <input type="hidden" name="personid" value="<?php echo $person['id']; ?>">
                                        <button type="submit" class="btn btn-panel panel-item">
                                            <h5 class="panel-title"><?php echo $person['fullname']; ?></h5>
                                            <p class="panel-author"><?php echo $gen_bsn; ?>: <?php echo $person['citizenid']; ?></p>
                                        </button>
                                    </form>
                                    </div>
                                <?php }?>
                                </div>
                            <?php } ?>
                        </div>
                        </div>
                    </div>
                <?php } ?>
                <?php } ?>
            </div>
        </main>
        <!-- <script src="assets/js/jquery-3.3.1.slim.min.js"></script>
        <script src="assets/js/popper.min.js"></script>
        <script src="assets/js/bootstrap.min.js"></script>
        <script src="assets/js/main.js"></script>
        <script src="assets/js/car-replace-names.js"></script>
    </body>
</html> -->
<?php
include("footer.php");
?>