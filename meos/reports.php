<?php
    require "header.php";
   
    $respone = false;
    if ($_SERVER['REQUEST_METHOD'] == "GET") {
        if ($_GET['type'] == "search") {
            $result = $con->query("SELECT * FROM reports WHERE concat(' ', title, ' ') LIKE '%".$con->real_escape_string($_GET['search'])."%' OR concat(' ', report, ' ') LIKE '%".$con->real_escape_string($_GET['search'])."%' ORDER BY created DESC");
            $search_array = [];
            while ($data = $result->fetch_assoc()) {
                $search_array[] = $data;
            }
        }
        if ($_GET['type'] == "show" || isset($_SESSION["reportid"]) && $_SESSION["reportid"] != NULL) {
            if (isset($_SESSION["reportid"]) && $_SESSION["reportid"] != NULL) {
                $reportId = $_SESSION["reportid"];
            } else {
                $reportId = $_GET['reportid'];
            }
            $query = $con->query("SELECT * FROM reports WHERE id = ".$con->real_escape_string($reportId));
            $selectedreport = $query->fetch_assoc();
            $lawids = json_decode($selectedreport["laws"], true);
            $profile = $con->query("SELECT * FROM profiles WHERE id = ".$con->real_escape_string($selectedreport["profileid"]));
            $profiledata = $profile->fetch_assoc();
            $lawdata = [];
            if (!empty($lawids)) {
                foreach($lawids as $lawid) {
                    $result = $con->query("SELECT * FROM laws WHERE id = ".$con->real_escape_string($lawid));
                    $lawdata[] = $result->fetch_assoc();
                }
            }
            $_SESSION["reportid"] = NULL;
        }elseif ($_GET['type'] == "delete") {
            if (isset($_SESSION["reportid"]) && $_SESSION["reportid"] != NULL) {
                $reportId = $_SESSION["reportid"];
            } else {
                $reportId = $_GET['reportid'];
            }
            $sql = "DELETE FROM reports WHERE id = ".$con->real_escape_string($reportId);
            if ($con->query($sql)) {
                $response = true;
            } else {
                echo "Error deleting record: " . mysqli_error($con);
                exit();
            }
        }
    }
    $name = explode(" ", $_SESSION["name"]);
    $firstname = $name[0];
    $last_word_start = strrpos($_SESSION["name"], ' ') + 1;
    $lastname = substr($_SESSION["name"], $last_word_start);
?>
                <?php if ($_SERVER['REQUEST_METHOD'] == "GET" && $_GET['type'] == "show" && !empty($selectedreport)) { ?>
                    
                    <div class="row">
                        <?php if ($lawdata != NULL) {?>
                            <?php foreach($lawdata as $law){?>
                                <div class="col-sm-12 col-md-6 col-lg-4 col-xl-3">
                                    <div class="law-item" data-toggle="tooltip" data-html="true" title="<?php echo $law['description']; ?>">
                                        <h5 class="lawlist-title"><?php echo $law['name']; ?></h5>
                                        <p class="lawlist-fine"><?php echo $reports_boete; ?>: €<?php echo $law['fine']; ?> <?php echo $reports_celstraf; ?>: <?php echo $law['months']; ?> <?php echo $reports_months; ?></p>
                                    </div>
                                </div>
                            <?php }?>
                        <?php } ?>
                    <div class="col-12 mb-3">
                        <form method="POST" action="createreport" class="d-inline" style="float:right; margin-left: 1vw;">
                            <input type="hidden" name="type" value="edit">
                            <input type="hidden" name="reportid" value="<?php echo $selectedreport['id']; ?>">
                            <button type="submit" class="btn btn-success btn-md my-0 ml-sm-2"><?php echo $reports_aanpassen; ?></button>
                        </form>
                        <form method="POST" action="reports" class="d-inline" style="float:right;">
                            <input type="hidden" name="type" value="delete">
                            <input type="hidden" name="reportid" value="<?php echo $selectedreport['id']; ?>">
                            <?php if ($_SESSION["role"] == "admin") { ?>
                            <button type="submit" class="btn btn-danger btn-md my-0 ml-sm-2"><?php echo $reports_verwijder; ?></button>
                            <?php } ?>
                        </form>
                    </div>
                    <div class="col-12">
                        <div class="report-show">
                            <h4 class="report-title"><?php echo $selectedreport["title"]; ?></h4>
                            <?php if ($profiledata != NULL) {?>
                                <p><?php echo $reports_prsn; ?>: <strong><?php echo $profiledata["fullname"]; ?></strong> (<?php echo $gen_by; ?>: <?php echo $profiledata["citizenid"]; ?>)
                            <?php } ?>
                            <hr>
                            <p class="report-description"><?php echo $selectedreport["report"]; ?></p>
                            <p class="report-author"><i><?php echo $reports_writtenby; ?>: <?php echo $selectedreport["author"]; ?></i></p>
                        </div>
                    </div>
                <?php } 
                ?>
                <div class="row gutters">
                    <div class="col-12">
                        <div class="notify info">
                            <div class="notify-body">
                                <span class="type"><?php echo $reports_reports; ?></span>
                                <main role="main" class="container"><?php echo $reports_info; ?>
                                    <div class="profile-container">
                                        <div class="profile-search">
                                            <br>
                                            <form method="GET" class="form-inline ml-auto">
                                                <input type="hidden" name="type" value="search">
                                                <div class="input-group w-100">
                                                    <input class="form-control" name="search" type="text" placeholder="<?php echo $gen_searchreport;?>" aria-label="Search">     
                                                    <div>
                                                        <button type="submit" class="btn btn-primary btn-police ml-2"><?php echo $gen_search; ?></button>
                                                    </div>
                                                </div>
                                            </form>
                                            <?php if ($_SERVER['REQUEST_METHOD'] != "GET" || $_SERVER['REQUEST_METHOD'] == "GET" && $_GET['type'] != "show") { ?>
                                                <a class="btn btn-primary mt-2 w-100" href="createreport"><?php echo $gen_newrport; ?></a>
                                            <?php }?>
                                        </div>
                                    </div>
                                </main>
                            </div>
		                </div>
                        
                    <?php if ($_SERVER['REQUEST_METHOD'] == "GET" && $_GET['type'] == "search") { ?>
                    <div class="notify danger">
                        <div class="notify-body">
                        <span class="type"><?php echo $gen_foundperson; ?></span>
                            <div class="panel-list">
                            <?php if (empty($search_array)) { ?>
                                <p><?php echo $gen_noreports; ?></p>
                            <?php } else { ?>
                                <div class="row">
                                <?php foreach($search_array as $report) {?>
                                    <div class="col-sm-12 col-md-6 col-lg-4 col-xl-3">
                                    <form method="GET">
                                        <input type="hidden" name="type" value="show">
                                        <input type="hidden" name="reportid" value="<?php echo $report['id']; ?>">
                                        <button type="submit" class="btn btn-panel panel-item">
                                            <h5 class="panel-title">#<?php echo $report['id']; ?> <?php echo $report['title']; ?></h5>
                                            <p class="panel-author"><?php echo $gen_by; ?>: <?php echo $report['author']; ?></p>
                                        </button>
                                    </form>
                                    </div>
                                <?php }?>
                                </div>
                            <?php } ?>
                        </div>
                    </div>
                <?php } ?>
</div>
            <!-- </div> -->
<?php
    include("footer.php");
?>