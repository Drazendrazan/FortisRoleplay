<?php
    require "header.php";
    if (!$_SESSION['loggedin']) {
        Header("Location: login");
    }
    if ($_SESSION["role"] != "admin") {
        Header("Location: dashboard");
    }
    
    $respone = false;
    if ($_SERVER['REQUEST_METHOD'] == "POST") {
        if (trim($_POST['type']) == NULL) {
            Header("Location:dashboard");
        }
        if ($_POST['type'] == "create") {
            $insert = $con->query("INSERT INTO users (username,password,name,role,rank,last_login) VALUES('".$con->real_escape_string($_POST['username'])."','".password_hash($con->real_escape_string($_POST['password']),PASSWORD_BCRYPT)."','".$con->real_escape_string($_POST['fullname'])."','user','".$con->real_escape_string($_POST['rank'])."','".date('Y-m-d')."')");
           if ($insert) {
                $respone = true;
            }
        } elseif ($_POST['type'] == "delete") {
            $sql = "DELETE FROM users WHERE id = ".$con->real_escape_string($_POST['deleteuser']);

            if ($con->query($sql)) {
                $respone = true;
            } else {
                echo "Error deleting record: " . mysqli_error($conn);
                exit();
            }
        } elseif ($_POST['type'] == "edit") {
            if( empty($_POST['edituser']))
            {
                echo "Ongeldig input";
                return;
            }        
        
            $query = $con->query("SELECT * FROM users WHERE id = ".$con->real_escape_string($_POST['edituser']));
            $selecteduser = $query->fetch_assoc();
        } elseif ($_POST['type'] == "realedit") {
            $update = $con->query("UPDATE users SET username = '".$con->real_escape_string($_POST['username'])."', name = '".$con->real_escape_string($_POST['fullname'])."', rank = '".$con->real_escape_string($_POST['rank'])."', role = '".$con->real_escape_string($_POST['role'])."' WHERE id = ".$_POST['userid']);
            if ($update) {
                $respone = true;
            } else {
                $response = false;
            }
        }
    }
    $name = explode(" ", $_SESSION["name"]);
    $firstname = $name[0];
    $last_word_start = strrpos($_SESSION["name"], ' ') + 1;
    $lastname = substr($_SESSION["name"], $last_word_start);

    $result = $con->query("SELECT * FROM users WHERE role = 'user'");
    $user_array = [];
    while ($data = $result->fetch_assoc()) { 
        $user_array[] = $data;
    }
?>
        <main role="main" class="container">
            <div class="content-introduction">
                <h3><?php echo $pf_head; ?></h3>
                <p class="lead"><?php echo $pf_info; ?></strong></p>
            </div>
            <br>
            <div class="users-container">
                <?php if ($_SERVER['REQUEST_METHOD'] == "POST" && $_POST['type'] == "edit") { ?>
                    <div class="left-panel-container">
                    <h5 class="panel-container-title">Pas gebruiker aan</h5>
                    <form method="POST">
                        <input type="hidden" name="type" value="realedit">
                        <input type="hidden" name="userid" value="<?php echo $selecteduser['id']; ?>">
                        <div class="input-group mb-2">
                            <input type="text" name="username" class="form-control login-user" value="<?php echo $selecteduser['username']; ?>" placeholder="<?php echo $gen_username;?>">
                        </div>
                        <div class="input-group mb-2">
                            <input type="text" name="fullname" class="form-control login-user" value="<?php echo $selecteduser['name']; ?>" placeholder="<?php echo $gen_fn;?>">
                        </div>
                        <!-- <div class="input-group mb-3">
                            <input type="text" name="rank" class="form-control login-user" value="<?php echo $selecteduser['rank']; ?>" placeholder="Rank">
                        </div> -->
                        <select class="form-control" style="margin-bottom:2vh;" name="rank" required>
                            <option value="Aspirant">Aspirant</option>
                            <option value="Surveillant">Surveillant</option>
                            <option value="Agent">Agent</option>
                            <option value="Hoofdagent">Hoofdagent</option>
                            <option value="Brigadier">Brigadier</option>
                            <option value="Inspecteur">Inspecteur</option>
                            <option value="Hoofdinspecteur">Hoofdinspecteur</option>
                        </select>
                        <select class="form-control" style="margin-bottom:2vh;" name="role" required>
                            <option value="user">Gebruiker</option>
                            <option value="admin">Administrator</option>
                        </select>
                        <div class="form-group">
                            <button type="submit" name="create" class="btn btn-primary btn-police w-100"><?php echo $war_create;?></button>
                        </div>
                    </form>
                </div> 
                <br>
                <?php } else { ?>
                <!-- Left Container -->
                <div class="left-panel-container">
                    <h5 class="panel-container-title"><?php echo $pf_adjust; ?></h5>
                    <?php if ($_SERVER['REQUEST_METHOD'] == "POST" && $_POST['type'] == "realedit" && $respone) {?>
                        <?php echo "<p style='color: #13ba2c;'>".$pf_ok."</p>"; ?>
                    <?php } ?>
                    <?php if ($_SERVER['REQUEST_METHOD'] == "POST" && $_POST['type'] == "realedit" && !$respone) {?>
                        <?php echo "<p style='color:#9f1010;'>".$pf_mok."</p>"; ?>
                    <?php } ?>
                    <form method="POST">
                        <input type="hidden" name="type" value="edit">
                        <div class="form-group">
                            <label for="userselect">Gebruiker</label>
                            <select class="form-control" name="edituser">
                            <?php foreach($user_array as $user){?>
                                <option value="<?php echo $user["id"] ?>"><?php echo $user['name']; ?></option>
                            <?php }?>
                            </select>
                        </div>
                        <div class="form-group">
                            <button type="submit" name="edit" class="btn btn-primary btn-police w-100"><?php echo $war_create;?></button>
                        </div>
                    </form>
                </div>  
                <br>
                <!-- Right Container -->
                <div class="right-panel-container">
                    <h5 class="panel-container-title">Verwijder gebruiker</h5>
                    <?php if ($_SERVER['REQUEST_METHOD'] == "POST" && $_POST['type'] == "delete" && $respone) {?>
                        <?php echo "<p style='color: #13ba2c;'>Gebruiker verwijderd!</p>"; ?>
                    <?php } ?>
                    <form method="POST">
                        <input type="hidden" name="type" value="delete">
                        <div class="form-group">
                            <label for="userselect">Gebruiker</label>
                            <select class="form-control" name="deleteuser">
                            <?php foreach($user_array as $user){?>
                                <option value="<?php echo $user["id"] ?>"><?php echo $user['name']; ?></option>
                            <?php }?>
                            </select>
                        </div>
                        <div class="form-group">
                            <button type="submit" name="delete" class="btn btn-primary btn-police w-100"><?php echo $pw_remove; ?></button>
                        </div>
                    </form>
                </div> 
                <br>
                <div class="left-panel-container">
                    <h5 class="panel-container-title">Voeg gebruiker toe</h5>
                    <?php if ($_SERVER['REQUEST_METHOD'] == "POST" && $_POST['type'] == "create" && $respone) {?>
                        <?php echo "<p style='color: #13ba2c;'>Gebruiker toegevoegd!</p>"; ?>
                    <?php } ?>
                    <form method="POST">
                        <input type="hidden" name="type" value="create">
                        <div class="input-group mb-2">
                            <input type="text" name="username" class="form-control login-user" value="" placeholder="<?php echo $gen_username;?>" required>
                        </div>
                        <div class="input-group mb-2">
                            <input type="password" name="password" class="form-control login-pass" value="" placeholder="<?php echo $pw_pw; ?>" required>
                        </div>
                        <div class="input-group mb-3">
                            <input type="text" name="fullname" class="form-control login-user" value="" placeholder="<?php echo $gen_fn;?>" required>
                        </div>
                        <select class="form-control" style="margin-bottom:2vh;" name="rank" required>
                            <option value="Aspirant">Aspirant</option>
                            <option value="Surveillant">Surveillant</option>
                            <option value="Agent">Agent</option>
                            <option value="Hoofdagent">Hoofdagent</option>
                            <option value="Brigadier">Brigadier</option>
                            <option value="Inspecteur">Inspecteur</option>
                            <option value="Hoofdinspecteur">Hoofdinspecteur</option>
                        </select>
                        <div class="form-group">
                            <button type="submit" name="create" class="btn btn-primary btn-police  w-100"><?php echo $war_create;?></button>
                        </div>
                    </form>
                </div> 
                <?php } ?>
            </div>
        </main>

<?php include("footer.php"); ?>