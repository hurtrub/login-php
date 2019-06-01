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
