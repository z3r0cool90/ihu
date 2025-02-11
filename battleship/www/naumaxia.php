<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
require_once "../lib/dbconnect.php";
require_once "../lib/board.php";
require_once "../lib/game.php";
require_once "../lib/users.php";

global $new_value;




$method = $_SERVER['REQUEST_METHOD'];
$request = explode('/', trim($_SERVER['PATH_INFO'],'/'));
$input = json_decode(file_get_contents('php://input'),true);


//$new_value= $input[0]["b_color"];



switch ($r=array_shift($request)) {
        case 'board' : 
        switch ($b=array_shift($request)) {
            case '':
            case null: handle_board($method);
            break;
            case 'winner': handle_winner($method);
            break;
             // Add this line for debugging      
            case 'piece': handle_piece($method, $request[0],$request[1],$request[2],$input);
            //$new_value
            break;
            case 'player': handle_player($method, $request[0],$input);
            break;
            default: header("HTTP/1.1 404 Not Found");
            break;
         }
                break;
        case 'status': 
            handle_status($method, $input);
        
	    //isws xreiastei na ksanagirisoyme edw
	    break;
        case 'players': handle_player($method, $request,$input);
                        break;
        case 'reset' : do_reset($method);
                        break;                        
        default:  header("HTTP/1.1 404 Not Found");
                        exit;
}

   /*  function handle_piece($method, $request, $input) {
        // Convert $request string to an array
        $requestArray = explode('/', $request);
    
        if ($method == 'GET' && count($requestArray) >= 2 && isset($requestArray[0], $requestArray[1]) && isset($input['username'])) {
            $x = $requestArray[0];
            $y = $requestArray[1];
            $username = $input['username']; // Assuming 'username' is passed in the input
    
            // Call the show_piece function with x, y, and username
            show_piece($x, $y, $username);
        } else {
            header("HTTP/1.1 400 Bad Request");
            print json_encode(['errormesg' => "Invalid request parameters."]);
        }
    } */

  /*   function handle_piece($method,$x,$y,$bcolor){
        if ($method == 'GET')
        show_piece($x, $y);
        else if ($method=='PUT')
        bombed_piece($x, $y, $bcolor);


    } */

    

    function handle_piece($method, $player, $x, $y, $bcolor_data) {
        if ($method == 'GET') {
            show_piece($player, $x, $y);
        } else if ($method == 'PUT') {
            // Extracting b_color from $bcolor_data if available, or set a default value
            $bcolor = isset($bcolor_data['b_color']) ? $bcolor_data['b_color'] : '';
    
            // Call bombed_piece with the extracted b_color
            bombed_piece($player, $x, $y, $bcolor);
        }
    }


function handle_board($method) {
 
        if($method=='GET') {
                show_board();
                //show_board_B();

        } else if ($method=='POST') {
                reset_board();
        }
		
}


function handle_player($method, $p,$input) {
        switch ($b=array_shift($p)) {
            	case '':
            	case null: if($method=='GET') {show_users($method);}
            			   else {header("HTTP/1.1 400 Bad Request"); 
            				 print json_encode(['errormesg'=>"Method $method not allowed here."]);}
                        break;
                case 'player_1': handle_user($method, $b,$input);
                        break;
                case 'player_2': handle_user($method, $b,$input);
                        break;
                default: header("HTTP/1.1 404 Not Found");
                        print json_encode(['errormesg'=>"Player $b not found."]);
                        break;
            }
    }

function handle_status($method,$next_plays_data) {
        if($method=='GET') {
            show_status();
        } 
        
        else if ($method=='PUT'){
            $p_turn = isset($next_plays_data['p_turn']) ? $next_plays_data['p_turn'] : '';
            update_pturn_status($p_turn);

        }
        
        
        else {
            header('HTTP/1.1 405 Method Not Allowed');
        }
    }

 function do_reset($method) {
	if($method=='GET'){
                reset_players();
                reset_game_status();
        }  else {
                header('HTTP/1.1 406 Reset failed!');
            }
}

function handle_winner($method) {
    global $mysqli;
    if ($method == 'GET') {
        // Assuming you have established the database connection ($mysqli)
       
        
        // Check if the connection was successful
        if ($mysqli->connect_error) {
            die("Connection failed: " . $mysqli->connect_error);
        }

        // Call the checkWinner function
        $result = checkWinner($mysqli);
        
        // Output the result or use it as needed in your application
        echo $result;

        // Close the database connection
        $mysqli->close();
    }
}



?>
