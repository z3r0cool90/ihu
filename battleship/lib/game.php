<?php
require_once "board.php";

function checkWinner($mysqli) {
	
    // Prepare and execute the procedure
    $sql = "CALL CheckWinner()";

    if ($stmt = $mysqli->prepare($sql)) {
        // Execute the procedure
        $stmt->execute();

        // Bind result variables
        $stmt->bind_result($message);

        // Fetch the result
        $stmt->fetch();

        // Close statement
        $stmt->close();

        // Return the message
		return json_encode(array("message" => $message));
    } else {
        // Return an error message as a JSON object
        return json_encode(array("error" => "Unable to prepare SQL statement."));
    }
}



function show_status() {
	global $mysqli;
	$sql = 'select * from game_status';
	$st = $mysqli->prepare($sql);

	$st->execute();
	$res = $st->get_result();
	
	header('Content-type: application/json');
	print json_encode($res->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT);
	
}
///////////////////////////////////////////////////////////////////////////////////////
//yparxei hdh san function => users.php alla me orisma
function show_users(){
	global $mysqli;
	$sql = 'select * from players';
	$st = $mysqli->prepare($sql);

	$st->execute();
	$res = $st->get_result();

	header('Content-type: application/json');
	print json_encode($res->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT);
}

///////////////////////////////////////////////////////////////////////////////////////
function update_game_status() {
	global $mysqli;
	
	$sql = 'select * from game_status';
	$st = $mysqli->prepare($sql);

	$st->execute();
	$res = $st->get_result();
	$status = $res->fetch_assoc();
	
	
	$new_status=null;
	$new_turn=null;
	
	$st3=$mysqli->prepare('select count(*) as aborted from players WHERE last_action< (NOW() - INTERVAL 5 MINUTE)');
	$st3->execute();
	$res3 = $st3->get_result();
	$aborted = $res3->fetch_assoc()['aborted'];
	if($aborted>0) {
		$sql = "UPDATE players SET username=NULL, token=NULL WHERE last_action< (NOW() - INTERVAL 5 MINUTE)";
		$st2 = $mysqli->prepare($sql);
		$st2->execute();
		if($status['status']=='started') {
			$new_status='aborted';
		}
	}

	
	$sql = 'select count(*) as c from players where username is not null';
	$st = $mysqli->prepare($sql);
	$st->execute();
	$res = $st->get_result();
	$active_players = $res->fetch_assoc()['c'];
	
	
	switch($active_players) {
		case 0: $new_status='not active'; break;
		case 1: $new_status='initialized'; break;
		case 2: $new_status='started'; 
				if($status['p_turn']==null) {
					$new_turn='player_1'; // It was not started before...
					set_fleet();////////////////////////////////////////////////
				}
				break;
	}

	$sql = 'update game_status set status=?, p_turn=?';
	$st = $mysqli->prepare($sql);
	$st->bind_param('ss',$new_status,$new_turn);
	$st->execute();
}
//////////////////////////////////////////////////////////////////////////////
/* function set_random_fleet() {
    $fleet = array();
    $i = 1;
    
    while ($i < 11) {
        $X = rand(1, 10);
        $Y = rand(1, 10);
        $coord = array($X, $Y);
        
        if (!in_array($coord, $fleet)) {
            array_push($fleet, $coord);
            $i++;
        }
    }
   return $fleet;
} */
///////////////////////////////////////////////////////////////////////////////
/* function set_fleet($a){
	set_random_fleet();
	for ($i=1, $i<11, $i++){
		$to_load= $fleet[$i];
		$sql = "UPDATE player_? SET b_color='G' WHERE x=$to_load[0] and y=$to_load[1]";
		$st2 = $mysqli->prepare($sql);
		$st2->execute();
	}

} */
//////////////////////////////////////////////////////////////////////////////
function set_fleet(){
	global $mysqli;
	
	$sql = 'call random_fleet_player_1()';
	$mysqli->query($sql);

	global $mysqli;
	
	$sql2 = 'call random_fleet_player_2()';
	$mysqli->query($sql2);

}



?>
