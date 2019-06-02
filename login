<?php
	session_start();
	if ($_SERVER["REQUEST_METHOD"] == "POST") {
		$username=$_POST['username'];
		
		if (!preg_match("/^[a-zA-Z0-9_]*$/",$username)) {
			$_SESSION['msg'] = "Username should not contain space and special characters!"; 
			header('location: index.php');
		}
		else{
		$fusername = $username;
		$pdo = new PDO ( 'mysql:host=localhost;dbname=structural;', 'root', 'admin' );
		$pdo->setAttribute( PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION );
		$stmt = $pdo->prepare(
		"SELECT
		*
		FROM
		manpower
		WHERE
		EmployeeCode = '$fusername'
		AND
		ContractStatus != 'S'
		"
		);
		
		$stmt->execute();
		$employeecode = $stmt->rowcount();
		while($row = $stmt->fetch(PDO::FETCH_ASSOC)){
			$employeename = $row["EmployeeName"];
			$employeecode = $row["EmployeeCode"];
		}
		
		if($employeecode==0){
			$_SESSION['msg'] = "Login Failed, Invalid Input!";
			header('location: ../login.php');
		}
		else{
			
				$_SESSION['id']=$employeecode;
				$cookie_value = $employeecode;
				setcookie($employeecode, $cookie_value, time() + (86400 * 30), "/");
				?>
				<script>
					window.alert('Login Success, Welcome <?php echo $employeename?>!');
					window.location.href='../index2.php';
				</script>
				<?php
			}
		}
		
		}
?>








#######################
2nd option

in login page

<?php include('header.php');?>
<div class="container login_page">
	</div class="row">
		<div class="col-md-12">
			<form action="login.php" method="post" enctype="form-data/multipart">
			<div class="login_page">
				<div id="login_page">
					<input type="text" class="form-control" id="username" name="username" placeholder="username">
					<input type="password" class="form-control" id="password" name="password" placeholder="password">
					<hr>
					<button class="btn btn-info form-control" id="login" name="login">Login</button>
					<hr>
					<a href="create_account.php">Create Account?</a>
				</div>
				<div style="color:red; font-size:12px;">
					<center>
						<?php
							session_start();
							if(isset($_SESSION['msg'])){
								echo $_SESSION['msg'];
								unset($_SESSION['msg']);
							}
						?>
					</center>
				</div>
			</div>
			</form>
		</div>
	</div>
</div>
<?php include('footer.php');?>




in login action
<?php
	session_start();
	if ($_SERVER["REQUEST_METHOD"] == "POST") {
		$username = $_POST["username"];
		$password = md5($_POST["password"]);
		$pdo = new PDO('mysql:host=localhost;dbname=1902','root','admin');
		$pdo -> setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
		$stmt = $pdo->prepare("SELECT * FROM login WHERE username = '$username'");
		$stmt->execute();
		$count1 = $stmt->rowCount();
		
		$pdo = new PDO('mysql:host=localhost;dbname=1902','root','admin');
		$pdo -> setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
		$stmt = $pdo->prepare("SELECT * FROM login WHERE password = '$password'");
		$stmt->execute();
		$count2 = $stmt->rowCount();
		
		if($count1 == 0){
			$_SESSION['msg'] = "Sorry Username Cannot Found!Please Register!";
			header('location: index.php');
		}elseif($count2 == 0){
			$_SESSION['msg'] = "Sorry password did not match!";
			header('location: index.php');
		}else{
			$_SESSION['id'] = $username;
			$cookie_value = $username;
			setcookie($username, $cookie_value, time() +(86400 * 30) ,"/");
			header('location: index2.php');
		}
	}
?>
