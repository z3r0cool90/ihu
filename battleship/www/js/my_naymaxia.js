var me={token:null,playernr:null,p_turn:null};///////////////////////////
var pcol={b_color:null};
var game_status={};
var playernr;
var username;
var board;
var x;
var y;
var last_update=new Date().getTime();//////////////////////////
var timer=null;////////////////////////////////////////////
var item_id;
var p;



$(document).ready(function() {
    draw_empty_board_A();
    draw_empty_board_B();
    fill_board();
    game_status_update();/////////////////////////////////////////////////////////
    $("#naymaxia_reset").click(reset_board);
    $("#button_init").click(initialize_button);
    $("#naymaxia_login").click(login_to_game);
    $('#move_div').hide();////////////////////////////////////////////////////////////
	$('naymaxia_table_A').click(click_on_piece);
    $('naymaxia_table_B').click(click_on_piece);
   
   
});








    function draw_empty_board_A() {
        var t='<table id="naymaxia_table_A">';
        for(var i=1; i<11; i++) {
            t += '<tr>';
        for(var j=1 ;j<11 ;j++) {
            t += '<td class="naymaxia_square_A" id="square_A_' +i+ '_' +j+ '">' + i +',' +j+ '</td>';
        }
        t+='</tr>';
        }
        t+='</table>';
        $('#naymaxia_board_A').html(t);
        $('.naymaxia_square_A').click(click_on_piece);
    }

    function draw_empty_board_B() {
        var t='<table id="naymaxia_table_B">';
        for(var i=1; i<11; i++) {
            t += '<tr>';
        for(var j=1 ;j<11 ;j++) {
            t += '<td class="naymaxia_square_B" id="square_B_' +i+ '_' +j+ '">' + i +',' +j+ '</td>';
        }
        t+='</tr>';
        }
        t+='</table>';
        $('#naymaxia_board_B').html(t);
        $('.naymaxia_square_B').click(click_on_piece);
    } 



//////////////////////////////////////////////////////////////////////////

    function fill_board() {
        
        $.ajax({
        url: "naumaxia.php/board/",
        method:"GET",
        headers: {"X-Token": me.token},
		success: fill_board_by_data,
        function (xhr, status, error) {
            console.log("Error filling board:", error);
            console.log("Status:", status);
            console.log("XHR object:", xhr);
        }
        });
    }
            
            

    function reset_board() {
        $.ajax(
        {url: "naumaxia.php/board/",
        method:"post",
        headers: {"X-Token": me.token},
        success: fill_board_by_data });
        alert(me.playernr + " gave up." + game_status.p_turn + " wins." );
        $('#game_initializer').show(2000);
        }

//////////////////////////////////////////////////////////////////
function initialize_button(){
    $.ajax({
        url: "naumaxia.php/reset", 
        method: "get",
        headers: {"X-Token": me.token},
        success: function() {
            // After successful reset, set the player turn to player_1
            game_status.p_turn = 'player_1';
            fill_board_by_data();
        }
    });
    alert("reseted DB");
}
         
//////////////////////////////////////////////////////////////////
    function fill_board_by_data(data) {
        for (var i = 0; i < data.length; i++) {
            var o = data[i];
            var id_A = '#square_A_' + o.x + '_' + o.y;
            var id_B = '#square_B_' + o.x + '_' + o.y; 
            var im = '<img class="piece" src="images/fog.png">'; 
            $(id_A).html(im);
            $(id_B).html(im); // Replace the content inside the specified cell in table B with the image
            }
                
	    $('.ui-droppable').droppable( "disable" );
		
//	      if(me && me.playernr!=null) {
//		  $('.piece'+me.playernr).draggable({start: start_dragging, stop: end_dragging, revert:true});
	            
	    if(me.playernr!=null && game_status.p_turn==me.playernr) {
		    $('#move_div').show(1000);
	    } else {
		    $('#move_div').hide(1000);
            }
        }
    function login_to_game() {
        if($("#username").val()=='') {
            alert('You have to set a username');
            return;
        }
        playernr = $("#player_nr").val();
        username= $("#username").val();
                
        fill_board();

        $.ajax({url:"naumaxia.php/players/"+playernr, 
            method: 'PUT',
            dataType: "json",
            contentType: 'application/json',
            headers: {"X-Token": me.token},
            data: JSON.stringify( {username: username, player_nr: playernr}),
            success: login_result,
            error: login_error});
        }
            

    function login_result(data) {
        me = data[0];
        $("#game_initializer").hide();
        update_info();
        game_status_update();
                
               
    }
    
 /*    function login_error(data,y,z,c) {
        var x = data.responseJSON;
        
        alert(x.errormesg);
    } */

    function login_error(xhr, status, error) {
        var x = data.responseJSON;
        console.log("Error filling board:", error);
        console.log("Status:", status);
        console.log("XHR object:", xhr);
        print (x);
    }


    function game_status_update(){
        clearTimeout(timer);
        $.ajax({url: "naumaxia.php/status/", success: update_status,headers: {"X-Token": me.token} }
        
        
        );
    }


    function update_info(){

        $('#game_info').html("I am Player: "+ me.player_nr+ ", my name is "+me.username +'<br>Token='+me.token+'<br>Game state: '+game_status.status+', '+ game_status.p_turn+' must play now.');
        if (me.player_nr== "player_1"){ 
            $('#pl_1').html(me.username)
        } else if (me.player_nr== "player_2"){
            $('#pl_2').html(me.username)
        }


    //needs handling to print 2nd player's username to div #pl_2
    }
            
            


           
            
    function update_status(data) {
        last_update=new Date().getTime();
	    var game_stat_old = game_status;
        game_status=data[0];
        update_info();
        clearTimeout(timer);
        if (game_status.status === "started" && playernr === "player_1") {
            var tablePrefix = 'A'; // Assuming player_1's table is 'A'
            var opp_board = 'player_1'; // Assuming you're checking your own board
        
            // Loop through your database or API to retrieve data
            for (var x = 1; x <= 10; x++) {
                for (var y = 1; y <= 10; y++) {
                    var cellId = 'square_' + tablePrefix + '_' + x + '_' + y;
                    var apiUrl = "naumaxia.php/board/piece/" + opp_board + "/" + x + "/" + y;
        
                    // Perform AJAX request for each cell
                    $.ajax({
                        url: apiUrl,
                        method: 'GET',
                        headers: { "X-Token": me.token },
                        dataType: 'json',
                        async: false, // Ensures synchronous execution (might impact performance)
                        success: function get_result(result) {
                            var pcol = result[0].b_color;
        
                            if (pcol === 'G') {
                                $('#' + cellId + ' img').attr('src', "images/boat.jpeg");
                            } else if (pcol === 'W') {
                                $('#' + cellId + ' img').attr('src', "images/sea.png");
                            }
                        },
                        error: function (xhr, status, error) {
                            console.log("Error fetching data from the API:", error);
                            console.log("Status:", status);
                            console.log("XHR object:", xhr);
                        }
                    });
                }
            }
        }

        else if
             (game_status.status === "started" && playernr === "player_2") {
                var tablePrefix = 'B'; // Assuming player_1's table is 'A'
                var opp_board = 'player_2'; // Assuming you're checking your own board
            
                // Loop through your database or API to retrieve data
                for (var x = 1; x <= 10; x++) {
                    for (var y = 1; y <= 10; y++) {
                        var cellId = 'square_' + tablePrefix + '_' + x + '_' + y;
                        var apiUrl = "naumaxia.php/board/piece/" + opp_board + "/" + x + "/" + y;
            
                        // Perform AJAX request for each cell
                        $.ajax({
                            url: apiUrl,
                            method: 'GET',
                            headers: { "X-Token": me.token },
                            dataType: 'json',
                            async: false, // Ensures synchronous execution (might impact performance)
                            success: function get_result(result) {
                                var pcol = result[0].b_color;
            
                                if (pcol === 'G') {
                                    $('#' + cellId + ' img').attr('src', "images/boat.jpeg");
                                } else if (pcol === 'W') {
                                    $('#' + cellId + ' img').attr('src', "images/sea.png");
                                }
                            },
                            error: function (xhr, status, error) {
                                console.log("Error fetching data from the API:", error);
                                console.log("Status:", status);
                                console.log("XHR object:", xhr);
                            }
                        });
                    }
                }
            }
        

        if(game_status.p_turn=="player_1" &&  me.player_nr!=null) {
            x=0;
    
            $('#move_div').show(1000);
            for (var x = 1; x <= 10; x++) {
                for (var y = 1; y <= 10; y++) {
                    var self_prefix='A';
                    var self_board="player_1";
                    var cellId = 'square_' + self_prefix + '_' + x + '_' + y;
                    var apiUrl = "naumaxia.php/board/piece/" + self_board + "/" + x + "/" + y;
        
                    // Perform AJAX request for each cell
                    $.ajax({
                        url: apiUrl,
                        method: 'GET',
                        headers: { "X-Token": me.token },
                        dataType: 'json',
                        async: false, // Ensures synchronous execution (might impact performance)
                        success: function get_result(result) {
                            var pcol = result[0].b_color;
        
                            if (pcol === 'R') {
                                $('#' + cellId + ' img').attr('src', "images/hit.png");
                            } else if (pcol === 'B') {
                                $('#' + cellId + ' img').attr('src', "images/error.png");
                            }
                        },
                        error: function (xhr, status, error) {
                            console.log("Error fetching data from the API:", error);
                            console.log("Status:", status);
                            console.log("XHR object:", xhr);
                        }
                    });
                }
            }
      
            setTimeout(function() { game_status_update();}, 15000);
            } 
            
            else if (game_status.p_turn=="player_2"){
                $('#move_div').show(1000);
                for (var x = 1; x <= 10; x++) {
                    for (var y = 1; y <= 10; y++) {
                        var self_prefix='B';
                        var self_board="player_2";
                        var cellId = 'square_' + self_prefix + '_' + x + '_' + y;
                        var apiUrl = "naumaxia.php/board/piece/" + self_board + "/" + x + "/" + y;
            
                        // Perform AJAX request for each cell
                        $.ajax({
                            url: apiUrl,
                            method: 'GET',
                            headers: { "X-Token": me.token },
                            dataType: 'json',
                            async: false, // Ensures synchronous execution (might impact performance)
                            success: function get_result(result) {
                                var pcol = result[0].b_color;
            
                                if (pcol === 'R') {
                                    $('#' + cellId + ' img').attr('src', "images/hit.png");
                                } else if (pcol === 'B') {
                                    $('#' + cellId + ' img').attr('src', "images/error.png");
                                }
                            },
                            error: function (xhr, status, error) {
                                console.log("Error fetching data from the API:", error);
                                console.log("Status:", status);
                                console.log("XHR object:", xhr);
                            }
                        });
                    }
                }
     
                setTimeout(function() { game_status_update();}, 15000);
            }
            
            else {
      
            $('#move_div').hide(1000);
            setTimeout(function() { game_status_update();}, 4000);
            }
                 
            // random fleet
    }
/////////////////////////////////////////////////////////////////////////////              

/// clicking on a piece function (bombard)

function click_on_piece(e) {
    var o = e.target;

    if (o.tagName != 'TD') 
        o = o.parentNode;

    var id = o.id;
    var a = id.split('_');
    var player = (a[1] == 'A' && playernr == 'player_1') ? "player_1" : "player_2";
    var x = a[2];
    var y = a[3];

    check_piece(player, x, y);

}
//////////////////////////////////////////////////////////////////////////////////////////

function check_piece(player, x, y) {
  // var tablePrefix = (player === "player_1") ? 'A' : 'B';
  //  var opp_board = (player === "player_1") ? "player_1" : "player_2";
 
  if(game_status.p_turn=="player_1"){
     tablePrefix1='B';
     opp_board1="player_2";
     cellId = 'square_' + tablePrefix1 + '_' + x + '_' + y;
     imageUrl = "images/hit.png";
     empty_sea= "images/sea.png";
     apiUrl = "naumaxia.php/board/piece/"+opp_board1+"/"+x+"/"+y;
    

    $.ajax({
        url: apiUrl,
        method: 'GET',
        headers: { "X-Token": me.token },
        dataType: 'json',
        success: function get_result(result){
            pcol.b_color=result[0].b_color;
            if (pcol.b_color == 'G'){
                $('#' + cellId + ' img').attr('src', imageUrl);
                inputPayload = {
                    'b_color': 'R'
                };
                update_hit(player,x,y,inputPayload);

            } else if (pcol.b_color == 'W'){
                $('#' + cellId + ' img').attr('src', empty_sea);
                inputPayload = {
                    'b_color': 'B'
                };
                update_hit(player,x,y,inputPayload);
            }
        },
        error: function (xhr, status, error) {
            console.log("Error fetching data from the API:", error);
            console.log("Status:", status);
            console.log("XHR object:", xhr);
        }
    }
                                    );

                    

}
else if (game_status.p_turn=="player_2"){

    tablePrefix2='A';
    opp_board2="player_1"; 
  
     cellId = 'square_' + tablePrefix2 + '_' + x + '_' + y;
     imageUrl = "images/hit.png";
     empty_sea= "images/sea.png";
     apiUrl = "naumaxia.php/board/piece/"+opp_board2+"/"+x+"/"+y;
    

    $.ajax({
        url: apiUrl,
        method: 'GET',
        headers: { "X-Token": me.token },
        dataType: 'json',
        success: function get_result(result){
            pcol.b_color=result[0].b_color;
            if (pcol.b_color == 'G'){
                $('#' + cellId + ' img').attr('src', imageUrl);
                inputPayload = {
                    'b_color': 'R'
                };
                update_hit(player,x,y,inputPayload);

            } else if (pcol.b_color == 'W'){
                $('#' + cellId + ' img').attr('src', empty_sea);
                inputPayload = {
                    'b_color': 'B'
                };
                update_hit(player,x,y,inputPayload);
            }
        },
        error: function (xhr, status, error) {
            console.log("Error fetching data from the API:", error);
            console.log("Status:", status);
            console.log("XHR object:", xhr);
        }
    });
}




}







     function update_hit(player,x,y, bcolor){
        if (game_status.p_turn=="player_1"){
    var attack_board ="player_2";
}
        else
        if (game_status.p_turn=="player_2"){
            var attack_board ="player_1";
         }
    var apiUrl = "naumaxia.php/board/piece/" +attack_board+'/'+ x + '/' + y;
    $.ajax({
        url:apiUrl, 
        method: 'PUT',
        dataType: "json",
        contentType: 'application/json',
        headers: {"X-Token": me.token},
        data: JSON.stringify( {b_color: bcolor}),
        success: changeTurn(player)
        });
    }
    function changeTurn(player){
        var apiUrl2 = "naumaxia.php/status/"
        var temp={'p_turn':player};


        $.ajax({
            url: apiUrl2,
            method: 'PUT',
            dataType: "json",
            contentType: 'application/json',
            headers: { "X-Token": me.token },
            data:JSON.stringify(temp),
        });

        $.ajax({
            url: "naumaxia.php/board/winner/",
            method: 'GET',
            dataType: "json",
            contentType: 'application/json',
            headers: { "X-Token": me.token },
            success: function(response) {
            var winnerMessage = response.message; 
            alert(winnerMessage);
        },
        
            
        });
    }




function hit_recorded_to_db(){
    var apiUrl = "naumaxia.php/board/"
    $.ajax({
        url:apiUrl, 
        method: 'GET',
        dataType: "json",
        contentType: 'application/json',
        headers: {"X-Token": me.token},
        success: function (){
            console.log("hit recorded to DB")
        }
    })
}

function hit_not_recorded_to_db(xhr, status, error) {
    console.log("Error putting data to the API:", error);
    console.log("Status:", status);
    console.log("XHR object:", xhr);
} 
//function move_result(data){
//    game_status_update();
//    fill_board_by_data(data);
//}
 /////////////////////////////////////////////////////////////
                // handle "hit"


function bombard_error(data) {
    var h = data.responseJSON;
    alert(h.errormesg);
    
}
                // count hits

                // declare win
///     function hit, bombard_error, kai apo
///     naumaxia na dw to board/piece put- kapou exw sfalma


