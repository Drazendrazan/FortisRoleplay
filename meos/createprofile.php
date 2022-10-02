<?php
    require "header.php";
    if (!$_SESSION['loggedin']) {
        Header("Location: login");
    }
    $respone = false;
    if ($_SERVER['REQUEST_METHOD'] == "POST") {
        if ($_POST['type'] == "create") {
            $note = nl2br($_POST["note"]);
            $insert = $con->query("INSERT INTO profiles (citizenid,fullname,avatar,fingerprint,dnacode,note,lastsearch) VALUES('".$con->real_escape_string($_POST['bsn'])."','".$con->real_escape_string($_POST['naam'])."','".$con->real_escape_string($_POST['avatar'])."','".$con->real_escape_string($_POST['vingerafdruk'])."','".$con->real_escape_string($_POST['dnacode'])."','".$con->real_escape_string($notitie)."',".time().")");
            if ($insert) {
                $last_id = $con->insert_id;
                $_SESSION["personid"] = $last_id;
                $respone = true;
                header('Location: profiles');
            }
        } elseif ($_POST['type'] == "edit") {
            $query = $con->query("SELECT * FROM profiles WHERE id = ".$con->real_escape_string($_POST['profileid']));
            $selectedprofile = $query->fetch_assoc();
        } elseif ($_POST['type'] == "realedit") {
            $notitie = nl2br($_POST["notitie"]);
            $update = $con->query("UPDATE profiles SET citizenid = '".$con->real_escape_string($_POST['bsn'])."', fullname = '".$con->real_escape_string($_POST['naam'])."', avatar = '".$con->real_escape_string($_POST['avatar'])."', fingerprint = '".$con->real_escape_string($_POST['vingerafdruk'])."', dnacode = '".$con->real_escape_string($_POST['dnacode'])."', note = '".$con->real_escape_string($notitie)."' WHERE id = ".$_POST['profileid']);
            if ($update) {
                $_SESSION["personid"] = $_POST['profileid'];
                $respone = true;
                header('Location: profiles');
            } else {
                $response = false;
            }
        }
    }
    $name = explode(" ", $_SESSION["name"]);
    $firstname = $name[0];
    $last_word_start = strrpos($_SESSION["name"], ' ') + 1;
    $lastname = substr($_SESSION["name"], $last_word_start);
?>
        <main role="main" class="container">
            <div class="content-introduction">
                <h3><?php echo $cc_create; ?></h3>
                <p class="lead"><?php echo $cc_info; ?></p>
            </div>
            <div class="createprofile-container">
            <?php if ($_SERVER['REQUEST_METHOD'] == "POST" && $_POST['type'] == "edit" && !empty($selectedprofile)) { ?>
                <form method="post">
                    <input type="hidden" name="type" value="realedit">
                    <input type="hidden" name="profileid" value="<?php echo $selectedprofile["id"]; ?>">
                    <div class="input-group mb-3">
                        <input type="text" name="bsn" class="form-control login-user" value="<?php echo $selectedprofile["citizenid"]; ?>" placeholder="<?php echo $gen_bsn; ?>" required>
                    </div>
                    <div class="input-group mb-2">
                        <input type="text" name="naam" class="form-control login-pass" value="<?php echo $selectedprofile["fullname"]; ?>" placeholder="<?php echo $cc_fn; ?>" required>
                    </div>
                    <div class="input-group mb-3">
                        <input type="text" name="avatar" class="form-control login-user" value="<?php echo $selectedprofile["avatar"]; ?>" placeholder="<?php echo $cc_photo; ?>" required>
                    </div>
                    <div class="input-group mb-3">
                        <input type="text" name="vingerafdruk" class="form-control login-user" value="<?php echo $selectedprofile["fingerprint"]; ?>" placeholder="<?php echo $gen_finger; ?>">
                    </div>
                    <div class="input-group mb-3">
                        <input type="text" name="dnacode" class="form-control login-user" value="<?php echo $selectedprofile["dnacode"]; ?>" placeholder="<?php echo $gen_dna; ?>">
                    </div>
                    <?php $notes = str_replace( "<br />", '', $selectedprofile["note"]); ?>
                    <div class="input-group mb-2">
                        <textarea name="notitie" class="form-control" value="<?php echo $notes; ?>" placeholder="Notitie"><?php echo $notes; ?></textarea>
                    </div>
                    <div class="form-group">
                        <button type="submit" name="create" class="btn btn-primary btn-police">Edit</button>
                    </div>
                </form>
            <?php } else { ?>
                <form method="post">
                    <input type="hidden" name="type" value="create">
                    <div class="input-group mb-3">
                        <input type="text" name="bsn" class="form-control login-user" value="" placeholder="<?php echo $gen_bsn; ?>" required>
                    </div>
                    <div class="input-group mb-2">
                        <input type="text" name="naam" class="form-control login-pass" value="" placeholder="<?php echo $cc_fn; ?>" required>
                    </div>
                    <div class="input-group mb-3">
                        <input type="text" name="avatar" class="form-control login-user" value="Linkje imgur oid" placeholder="<?php echo $cc_photo; ?>">
                    </div>
                    <div class="input-group mb-3">
                        <input type="text" name="vingerafdruk" class="form-control login-user" value="" placeholder="<?php echo $gen_finger; ?>">
                    </div>
                    <div class="input-group mb-3">
                        <input type="text" name="dnacode" class="form-control login-user" value="" placeholder="<?php echo $gen_dna; ?>">
                    </div>
                    <div class="input-group mb-2">
                        <textarea name="notitie" class="form-control" value="" placeholder="<?php echo $gen_note; ?>"></textarea>
                    </div>
                    <div class="form-group">
                        <button type="submit" name="create" class="btn btn-primary btn-police"><?php echo $gen_add; ?></button>
                    </div>
                </form>
            <?php } ?>
            </div>
            <?php
include("footer.php");
?>