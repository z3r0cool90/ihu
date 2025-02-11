<?php

function show_board() {
	global $mysqli;
	$sql = 'select * from player_1'; 'select * from player_2';
	$st = $mysqli->prepare($sql);

	$st->execute();
	$res = $st->get_result();
	
	header('Content-type: application/json');
	print json_encode($res->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT);
    
}



/* function show_piece($x, $y, $username) {
    global $mysqli;

    // Fetch the current player's turn from the 'players' table based on username
    $sql_current_player = "SELECT player_nr FROM players WHERE username = ?";
    $st_current_player = $mysqli->prepare($sql_current_player);
    $st_current_player->bind_param('s', $username);
    $st_current_player->execute();
    $result_current_player = $st_current_player->get_result();
    $row_current_player = $result_current_player->fetch_assoc();
    $current_player = $row_current_player['player_nr']; // This will have 'player_1' or 'player_2'

    // Determine the opponent's table based on the current player's turn
    $opponent_table = ($current_player === 'player_1') ? 'player_2' : 'player_1';

    $sql = "SELECT `b_color` FROM $opponent_table WHERE x = ? AND y = ?";
    $st = $mysqli->prepare($sql);

    // Binding parameters for x and y
    $st->bind_param('ii', $x, $y);
    $st->execute();
    $res = $st->get_result();

    header('Content-type: application/json');
    print json_encode($res->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT);
} */

function show_piece($player, $x, $y){
	global $mysqli;

	$sql = "SELECT `b_color` FROM {$player} WHERE x=? AND y=?";

	$st= $mysqli->prepare($sql);
	$st->bind_param('ii', $x , $y);
	$st->execute();
	$res = $st->get_result();
	header('Content-type: application/json');
	print json_encode($res->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT);
}

///////////////////////////////////////////////////////////////////////

////// **********************************


function bombed_piece($player, $x, $y, $bcolor_data) {
    global $mysqli;

    // Extracting b_color from $bcolor_data if available, or set a default value
    $bcolor = isset($bcolor_data['b_color']) ? $bcolor_data['b_color'] : '';

    // Prepare and execute the SQL query to update b_color for the specified coordinates
    $sql = "UPDATE {$player} SET b_color=? WHERE x=? AND y=?";
    $st = $mysqli->prepare($sql);
    
    // Assuming b_color is a string, x and y are integers
    $st->bind_param('sii', $bcolor, $x, $y);
    $st->execute();

    // Assuming show_board() retrieves the updated board data
    $board_data = show_board();

    // Send the updated board data as a JSON response
    header('Content-type: application/json');
    print json_encode($board_data, JSON_PRETTY_PRINT);
	$sql2="call change_p_turn();";
	$mysqli->query($sql2);
}

function update_pturn_status($next_plays_data) {
    // Log the received data
    error_log("Received data: " . print_r($next_plays_data, true));

    global $mysqli;

    // Fetch the current p_turn from the database
    $fetch_sql = "SELECT p_turn FROM game_status";
    $fetch_stmt = $mysqli->prepare($fetch_sql);

    if ($fetch_stmt && $fetch_stmt->execute()) {
        $result = $fetch_stmt->get_result();

        if ($result) {
            $row = $result->fetch_assoc();
            $current_turn = $row['p_turn'];

            // Logic to determine the next player's turn
            $new_turn = ($current_turn === 'player_1') ? 'player_2' : 'player_1';

            // SQL query to update p_turn column in game_status table
            $update_sql = "UPDATE game_status SET p_turn = ?";
            $update_stmt = $mysqli->prepare($update_sql);

            if ($update_stmt) {
                $update_stmt->bind_param('s', $new_turn);

                if ($update_stmt->execute()) {
                    echo "p_turn updated successfully to $new_turn";
                    $mysqli->commit();
                } else {
                    echo "Error updating p_turn: " . $mysqli->error;
                }
            } else {
                echo "Prepare statement error: " . $mysqli->error;
            }
        } else {
            echo "Error fetching current p_turn: " . $mysqli->error;
        }
    } else {
        echo "Error executing fetch statement: " . $mysqli->error;
    }
}









/* ***************************ORIGINAL CODE*****************************
function show_board_A() {
	global $mysqli;
	$sql = 'select * from player_1';
	$st = $mysqli->prepare($sql);

	$st->execute();
	$res = $st->get_result();
	
	header('Content-type: application/json');
	print json_encode($res->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT);
}

function show_board_B() {
	global $mysqli;
	$sql = 'select * from player_2';
	$st = $mysqli->prepare($sql);

	$st->execute();
	$res = $st->get_result();
	
	header('Content-type: application/json');
	print json_encode($res->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT); 
}*************************************************************************/

function reset_board() {
	global $mysqli;
	
	$sql = 'call clean_board()';
	$mysqli->query($sql);
	show_board();
	/*show_board_B(); */
	
}
///////////////////////////////////////////////////////////////////////////////
function reset_players() {
	global $mysqli;
	
	$sql = 'call reset_players()';
	$mysqli->query($sql);
}

function reset_game_status() {
	global $mysqli;
	
	$sql = 'call reset_game_status()';
	$mysqli->query($sql);
	
}
///////////////////////////////////////////////////////////////////////////////////
?>
